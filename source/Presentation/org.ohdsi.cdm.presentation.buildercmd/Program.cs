﻿using System;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Threading;
using CommandLine;
using org.ohdsi.cdm.framework.core;
using org.ohdsi.cdm.framework.core.Controllers;
using org.ohdsi.cdm.framework.shared.Enums;
using org.ohdsi.cdm.framework.shared.Helpers;
using CommandLine.Text;

namespace org.ohdsi.cdm.presentation.buildercmd
{
    class Program
    {
        /// <summary>
        /// Command line options for CDM Builder
        /// </summary>
        /// <remarks>Priority order: 
        /// 1. Command line
        /// 2. Builder database for existing CDM builds
        /// 3. BuildingManager.exe.Config file
        /// 4. Defaults
        /// </remarks>
        private class Options
        {
            //[Usage(ApplicationAlias = "CDM Builder command line interface")]
            //public static IEnumerable<Example> Examples
            //{
            //    get
            //    {
            //        yield return new Example("Example usage", 
            //            new Options { BuilderConnectionString = "<connection string to Builder database",
            //                SourceConnectionString = "<connection string to Native database",
            //                DestinationConnectionString = "<connection string to CDM database",
            //                VocabularyConnectionString = "<connection string to Vocabulary database",
            //                LoadId = 1
            //            });                    
            //    }
            //}

            public static Options Default
            {
                get
                {
                    return new Options
                    {
                        LoadId = 9999,
                        ChunkSize = 0,
                        BuildersCount = 1,
                        NativeSchema = "native",
                        CdmSchema = "cdm",
                        S3AwsAccessKeyId = Environment.GetEnvironmentVariable("s3_aws_access_key_id"),
                        S3AwsSecretAccessKey = Environment.GetEnvironmentVariable("s3_aws_secret_access_key"),
                        Ec2AwsAccessKeyId = Environment.GetEnvironmentVariable("ec2_aws_access_key_id"),
                        Ec2AwsSecretAccessKey = Environment.GetEnvironmentVariable("ec2_aws_secret_access_key"),
                    };
                }
            }

            [Option('b', "builderconnectionstring", HelpText = "Connection string to Builder database", Required = false)]
            public string BuilderConnectionString { get; set; }

            [Option('s', "sourceconnectionstring", HelpText = "Connection string to Native database", Required = false)]
            public string SourceConnectionString { get; set; }

            [Option('d', "destinationconnectionstring", HelpText = "Connection string to CDM database", Required = false)]
            public string DestinationConnectionString { get; set; }

            [Option('v', "vocabularyconnectionstring", HelpText = "Connection string to CDM Vocabulary database", Required = false)]
            public string VocabularyConnectionString { get; set; }

            [Option('r', "vendor", HelpText = "Native dataset Vendor (Vendor Schema Id from HIX database)", Required = false)]
            public Vendors Vendor { get; set; }

            [Option('c', "chunksize", HelpText = "CDM Build Batch size", Required = false)]
            public int ChunkSize { get; set; }

            [Option('n', "builderscount", HelpText = "Number of concurrent CDM Builders on one server", Required = false)]
            public int BuildersCount { get; set; }

            [Option('a', "s3awsaccesskeyid", HelpText = "S3 AWS Access Key Id", Required = false)]
            public string S3AwsAccessKeyId { get; set; }

            [Option('e', "s3awssecretaccesskey", HelpText = "S3 AWS Secret Access Key", Required = false)]
            public string S3AwsSecretAccessKey { get; set; }

            [Option("ec2awsaccesskeyid", HelpText = "EC2 AWS Access Key Id", Required = false)]
            public string Ec2AwsAccessKeyId { get; set; }

            [Option("ec2awssecretaccesskey", HelpText = "EC2 AWS Secret Access Key", Required = false)]
            public string Ec2AwsSecretAccessKey { get; set; }

            [Option('l', "loadid", HelpText = "CDM Build Load Id (from HIX database)", Required = false)]
            public int LoadId { get; set; }

            [Option("nativeSchema", HelpText = "Native database schema name", Required = false)]
            public string NativeSchema { get; set; }

            [Option("cdmSchema", HelpText = "CDM database schema name", Required = false)]
            public string CdmSchema { get; set; }
        }

        private static bool IsBuilderDBAvailable(string builderConnectionString)
        {
            try
            {
                using (var c = SqlConnectionHelper.OpenMSSQLConnection(builderConnectionString))
                {                    
                }

                return true;
            }
            catch (Exception e)
            {
                Trace.WriteLine(Logger.CreateExceptionString(e));                
                return false;
            }
        }

        static int Main(string[] args)
        {
            try
            {
                var parser = new Parser(settings =>
                {
                    settings.IgnoreUnknownArguments = true;
                });

                var parserResult = parser.ParseArguments<Options>(args);
                if (parserResult.Tag == ParserResultType.Parsed)
                {
                    return parserResult.MapResult(
                        options =>
                        {
                            return RunCdmCommand(options);
                        },
                        errors => 1);
                }
                else
                {
                    var helpText = HelpText.AutoBuild(parserResult);
                    helpText.Heading = string.Format("CDM Builder command line interface v.{0}", typeof(Program).Assembly.GetName().Version);
                    helpText.MaximumDisplayWidth = 80;
                    Trace.WriteLine(helpText);

                    return 1;
                }
            }
            catch (Exception exc)
            {
                Trace.WriteLine(exc.Message);
                return 1;
            }
        }

        private static int RunCdmCommand(Options options)
        {
            try
            {
                if (options == null)
                    throw new ArgumentNullException("No options supplied");

                InitSettings(options);

                ValidateSettings();
                Settings.Current.Save();

                WriteInfoToConsole();

                var buildingController = new BuildingController();
                buildingController.Process();

                Trace.WriteLine(buildingController.Builder.State);
                while (buildingController.Builder.State == BuilderState.Running ||
                       buildingController.Builder.State == BuilderState.Stopping)
                {
                    buildingController.Refresh();
                    Thread.Sleep(10000);
                }
                Trace.WriteLine(buildingController.Builder.State.ToString());

                return buildingController.Builder.State == BuilderState.Error ? 1 : 0;
            }
            catch (Exception e)
            {
                Trace.WriteLine(Logger.CreateExceptionString(e));                
                if (Settings.Current.Building.Id != null)
                    Logger.WriteError(e);
                return 1;
            }
        }

        private static void InitSettings(Options opt)
        {
            var configBuilderConnectionString = ReadFromConfigFile();
            var cmdBuilderConnectionString = opt.BuilderConnectionString;
            var builderConnectionString = string.Empty;
            if (!string.IsNullOrWhiteSpace(cmdBuilderConnectionString))
            {
                if (IsBuilderDBAvailable(cmdBuilderConnectionString))
                    builderConnectionString = cmdBuilderConnectionString;
                else
                    Trace.WriteLine("Could not connect to Builder Database '{0}'",
                        cmdBuilderConnectionString);
            }
            else if (!string.IsNullOrWhiteSpace(configBuilderConnectionString))
            {
                if (IsBuilderDBAvailable(configBuilderConnectionString))
                    builderConnectionString = configBuilderConnectionString;
                else
                {
                    Trace.WriteLine("Could not connect to Builder Database '{0}'",
                        configBuilderConnectionString);
                    throw new Exception(
                        string.Format("Could not connect to Builder Database '{0}'",
                        configBuilderConnectionString));
                }
            }

            if (string.IsNullOrEmpty(builderConnectionString))
            {
                Trace.WriteLine("Builder Connection String is not set");
                throw new Exception("Builder Connection String is not set");
            }

            Settings.Initialize(builderConnectionString, Environment.MachineName);

            if (Settings.Current.Builder.IsNew)
            {
                if (opt.ChunkSize != default(int))
                   Settings.Current.Building.BatchSize = opt.ChunkSize;
                if (opt.BuildersCount != default(int))
                    Settings.Current.Builder.MaxDegreeOfParallelism = opt.BuildersCount;
            }

            if (!Settings.Current.Building.Id.HasValue)
            {
                if (opt.ChunkSize != default(int))
                   Settings.Current.Building.BatchSize = opt.ChunkSize;
                if (opt.BuildersCount != default(int))
                    Settings.Current.Builder.MaxDegreeOfParallelism = opt.BuildersCount;

                Settings.Current.Builder.Folder = AppDomain.CurrentDomain.BaseDirectory;

                if (!string.IsNullOrWhiteSpace(opt.SourceConnectionString))
                    Settings.Current.Building.RawSourceConnectionString = opt.SourceConnectionString;
                if (!string.IsNullOrWhiteSpace(opt.DestinationConnectionString))
                    Settings.Current.Building.RawDestinationConnectionString = opt.DestinationConnectionString;
                if (!string.IsNullOrWhiteSpace(opt.VocabularyConnectionString))
                    Settings.Current.Building.RawVocabularyConnectionString = opt.VocabularyConnectionString;
                if (opt.Vendor != default(Vendors))
                    Settings.Current.Building.Vendor = opt.Vendor;

                Settings.Current.Building.Batches = Options.Default.ChunkSize;

                if (opt.LoadId != default(int))
                    ConfigurationManager.AppSettings["loadId"] = opt.LoadId.ToString();
                if (string.IsNullOrWhiteSpace(ConfigurationManager.AppSettings["loadId"]) 
                    || ConfigurationManager.AppSettings["loadId"] == "0")
                    ConfigurationManager.AppSettings["loadId"] = Options.Default.LoadId.ToString();

                if (!string.IsNullOrWhiteSpace(opt.S3AwsAccessKeyId))
                   Settings.Current.S3AwsAccessKeyId = opt.S3AwsAccessKeyId;
                if (string.IsNullOrWhiteSpace(Settings.Current.S3AwsAccessKeyId))
                   Settings.Current.S3AwsAccessKeyId = Options.Default.S3AwsAccessKeyId;

                if (!string.IsNullOrWhiteSpace(opt.S3AwsSecretAccessKey))
                   Settings.Current.S3AwsSecretAccessKey = opt.S3AwsSecretAccessKey;
                if (string.IsNullOrWhiteSpace(Settings.Current.S3AwsSecretAccessKey))
                   Settings.Current.S3AwsSecretAccessKey = Options.Default.S3AwsSecretAccessKey;

                if (!string.IsNullOrWhiteSpace(opt.Ec2AwsSecretAccessKey))
                   Settings.Current.Ec2AwsSecretAccessKey = opt.Ec2AwsSecretAccessKey;
                if (string.IsNullOrWhiteSpace(Settings.Current.Ec2AwsSecretAccessKey))
                   Settings.Current.Ec2AwsSecretAccessKey = Options.Default.Ec2AwsSecretAccessKey;
            }
        }

        private static string ReadFromConfigFile()
        {
            var builderConnectionString = string.Empty;
            var exePath = Path.Combine(Environment.CurrentDirectory, "org.ohdsi.cdm.presentation.buildingmanager.exe");
            if (File.Exists(exePath))
            {
                var config = ConfigurationManager.OpenExeConfiguration(exePath);
                if (config.ConnectionStrings != null &&
                    config.ConnectionStrings.ConnectionStrings != null &&
                    config.ConnectionStrings.ConnectionStrings["Builder"] != null)
                {
                    builderConnectionString = config.ConnectionStrings.ConnectionStrings["Builder"].ConnectionString;
                }

                if (config.AppSettings != null && config.AppSettings.Settings != null)
                {
                    if (config.AppSettings.Settings["s3_aws_access_key_id"] != null)
                        Settings.Current.S3AwsAccessKeyId = config.AppSettings.Settings["s3_aws_access_key_id"].Value;

                    if (config.AppSettings.Settings["s3_aws_secret_access_key"] != null)
                        Settings.Current.S3AwsSecretAccessKey = config.AppSettings.Settings["s3_aws_secret_access_key"].Value;

                    if (config.AppSettings.Settings["ec2_aws_access_key_id"] != null)
                       Settings.Current.Ec2AwsAccessKeyId = config.AppSettings.Settings["ec2_aws_access_key_id"].Value;

                    if (config.AppSettings.Settings["ec2_aws_secret_access_key"] != null)
                       Settings.Current.Ec2AwsSecretAccessKey = config.AppSettings.Settings["ec2_aws_secret_access_key"].Value;

                    if (config.AppSettings.Settings["bucket"] != null)
                        Settings.Current.Bucket = config.AppSettings.Settings["bucket"].Value;
                   
                    if (config.AppSettings.Settings["loadId"] != null)
                        ConfigurationManager.AppSettings["loadId"] = config.AppSettings.Settings["loadId"].Value;
                    else
                        ConfigurationManager.AppSettings["loadId"] = Options.Default.LoadId.ToString();
                }
            }
            return builderConnectionString;
        }

        private static void ValidateSettings()
        {
            if (string.IsNullOrWhiteSpace(Settings.Current.Building.RawSourceConnectionString))
                throw new ArgumentException("Source Connection String is not set");

            if (string.IsNullOrWhiteSpace(Settings.Current.Building.RawDestinationConnectionString))
                throw new ArgumentException("Destination Connection String is not set");

            if (string.IsNullOrWhiteSpace(Settings.Current.Building.RawVocabularyConnectionString))
                throw new ArgumentException("Vocabulary Connection String is not set");

            if (Settings.Current.Builder.MaxDegreeOfParallelism < 1)
                throw new ArgumentException("MaxDegreeOfParallelism must be greater than zero");

            if (Settings.Current.Building.BatchSize < 1)
                throw new ArgumentException("BatchSize must be greater than zero");

            if (Settings.Current != null && Settings.Current.Building != null && Settings.Current.Building.DestinationEngine.Database == Database.Redshift)
            {
                if (string.IsNullOrWhiteSpace(Settings.Current.Bucket))
                    throw new ArgumentException("S3 Bucket is not set");

                if (string.IsNullOrWhiteSpace(Settings.Current.S3AwsAccessKeyId))
                    throw new ArgumentException("S3 AWS Access Key Id is not set");

                if (string.IsNullOrWhiteSpace(Settings.Current.S3AwsSecretAccessKey))
                    throw new ArgumentException("S3 AWS Secret Access Key is not set");

                if (string.IsNullOrWhiteSpace(Settings.Current.Ec2AwsAccessKeyId))
                   throw new ArgumentException("EC2 AWS Access Key Id is not set");

                if (string.IsNullOrWhiteSpace(Settings.Current.Ec2AwsSecretAccessKey))
                   throw new ArgumentException("EC2 AWS Secret Access Key is not set");
            }
        }

        private static void WriteInfoToConsole()
        {
            Trace.WriteLine("Starting parameters:");
            Trace.WriteLine("BuilderId = " + Settings.Current.Builder.Id);
            Trace.WriteLine("BuildingId = " + Settings.Current.Building.Id);
            Trace.WriteLine(string.Empty);
            Trace.WriteLine("BatchSize = " + Settings.Current.Building.BatchSize);
            Trace.WriteLine("MaxDegreeOfParallelism = " + Settings.Current.Builder.MaxDegreeOfParallelism);
            Trace.WriteLine(string.Format("Folder = '{0}'", Settings.Current.Builder.Folder));
            Trace.WriteLine(string.Empty);
            Trace.WriteLine("Source = " + Settings.Current.Building.RawSourceConnectionString);
            Trace.WriteLine(string.Empty);
            Trace.WriteLine("Destination = " + Settings.Current.Building.RawDestinationConnectionString);
            Trace.WriteLine(string.Empty);
            Trace.WriteLine("Vocabulary = " + Settings.Current.Building.RawVocabularyConnectionString);
            Trace.WriteLine(string.Empty);
            Trace.WriteLine("EC2 AWS Key = " + Settings.Current.Ec2AwsAccessKeyId);
            Trace.WriteLine("EC2 AWS Secret Key = " + Settings.Current.Ec2AwsSecretAccessKey);
            Trace.WriteLine("S3 AWS Key = " + Settings.Current.S3AwsAccessKeyId);
            Trace.WriteLine("S3 AWS Secret Key = " + Settings.Current.S3AwsSecretAccessKey);
            Trace.WriteLine("S3 Bucket = " + Settings.Current.Bucket);
            Trace.WriteLine(string.Empty);
            Trace.WriteLine("Vendor = " + Settings.Current.Building.Vendor);
            Trace.WriteLine("LoadId = " + ConfigurationManager.AppSettings["loadId"]);
            Trace.WriteLine(new string('-', 80));
            Trace.WriteLine(string.Empty);
        }
    }
}