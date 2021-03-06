﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using org.ohdsi.cdm.framework.entities.Builder;
using org.ohdsi.cdm.framework.entities.Omop;

namespace org.ohdsi.cdm.framework.entities.DataReaders.v5 
{
	public class DrugExposureDataReader52 : IDataReader
   {
      private readonly IEnumerator<DrugExposure> exposureEnumerator;
      private readonly KeyMasterOffset offset;

		// A custom DataReader is implemented to prevent the need for the HashSet to be transformed to a DataTable for loading by SqlBulkCopy
      public DrugExposureDataReader52(List<DrugExposure> batch, KeyMasterOffset offset) 
      {
         exposureEnumerator = batch.GetEnumerator();
         this.offset = offset;
		}

		public bool Read()
		{
		  return exposureEnumerator.MoveNext();
		}
	   
	   public int FieldCount 
      {
			get { return 22; }
		}

      public object GetValue(int i)
      {
         if (exposureEnumerator.Current == null) return null;

         switch (i)
         {
            case 0:
               return exposureEnumerator.Current.Id + offset.DrugExposureOffset;
            case 1:
               return exposureEnumerator.Current.PersonId;
            case 2:
               return exposureEnumerator.Current.ConceptId;
            case 3:
               return exposureEnumerator.Current.StartDate;
            case 4:
               return exposureEnumerator.Current.StartTime ?? exposureEnumerator.Current.StartDate.ToString("HH:mm:ss", CultureInfo.InvariantCulture);
            case 5:
               return exposureEnumerator.Current.EndDate;
            case 6:
               return exposureEnumerator.Current.EndTime;
            case 7:
               return exposureEnumerator.Current.VerbatimEndDate;
            case 8:
               return exposureEnumerator.Current.TypeConceptId;
            case 9:
               return exposureEnumerator.Current.StopReason;
            case 10:
               return exposureEnumerator.Current.Refills;
            case 11:
               return exposureEnumerator.Current.Quantity;
            case 12:
               return exposureEnumerator.Current.DaysSupply;
            case 13:
               return exposureEnumerator.Current.Sig;
            case 14:
               return exposureEnumerator.Current.RouteConceptId ?? 0;
            case 15:
               return exposureEnumerator.Current.LotNumber;
            case 16:
               return exposureEnumerator.Current.ProviderId == 0 ? null : exposureEnumerator.Current.ProviderId;
            case 17:
               return exposureEnumerator.Current.VisitOccurrenceId + offset.VisitOccurrenceOffset;
            case 18:
               return exposureEnumerator.Current.SourceValue;
            case 19:
               return exposureEnumerator.Current.SourceConceptId;
            case 20:
               return exposureEnumerator.Current.RouteSourceValue;
            case 21:
               return exposureEnumerator.Current.DoseUnitSourceValue;
            default:
               throw new NotImplementedException();
         }
      }

      public string GetName(int i)
      {
         if (exposureEnumerator.Current == null) return null;

         switch (i)
         {
            case 0:
               return "Id";
            case 1:   
               return "PersonId";
            case 2:   
               return "ConceptId";
            case 3:   
               return "StartDate";
            case 4:   
               return "StartTime";
            case 5:   
               return "EndDate";
            case 6:   
               return "EndTime";
            case 7:   
               return "VerbatimEndDate";
            case 8:   
               return "TypeConceptId";
            case 9:   
               return "StopReason";
            case 10:  
               return "Refills";
            case 11:  
               return "Quantity";
            case 12:  
               return "DaysSupply";
            case 13:  
               return "Sig";
            case 14:  
               return "RouteConceptId";
            case 15:  
               return "LotNumber";
            case 16:  
               return "ProviderId";
            case 17:  
               return "VisitOccurrenceId";
            case 18:  
               return "SourceValue";
            case 19:  
               return "SourceConceptId";
            case 20:  
               return "RouteSourceValue";
            case 21:  
               return "DoseUnitSourceValue";
            default:
               throw new NotImplementedException();
         }
      }

      #region implementationn not required for SqlBulkCopy
      public bool NextResult()
      {
         throw new NotImplementedException();
      }

      public void Close()
      {
         throw new NotImplementedException();
      }

      public bool IsClosed
      {
         get { throw new NotImplementedException(); }
      }

      public int Depth
      {
         get { throw new NotImplementedException(); }
      }

      public DataTable GetSchemaTable()
      {
         throw new NotImplementedException();
      }

      public int RecordsAffected
      {
         get { throw new NotImplementedException(); }
      }

      public void Dispose()
      {
         throw new NotImplementedException();
      }

      public bool GetBoolean(int i)
      {
         return (bool)GetValue(i);
      }

      public byte GetByte(int i)
      {
         return (byte)GetValue(i);
      }

      public long GetBytes(int i, long fieldOffset, byte[] buffer, int bufferoffset, int length)
      {
         throw new NotImplementedException();
      }

      public char GetChar(int i)
      {
         return (char)GetValue(i);
      }

      public long GetChars(int i, long fieldoffset, char[] buffer, int bufferoffset, int length)
      {
         throw new NotImplementedException();
      }

      public IDataReader GetData(int i)
      {
         throw new NotImplementedException();
      }

      public string GetDataTypeName(int i)
      {
         throw new NotImplementedException();
      }

      public DateTime GetDateTime(int i)
      {
         return (DateTime)GetValue(i);
      }

      public decimal GetDecimal(int i)
      {
         return (decimal)GetValue(i);
      }

      public double GetDouble(int i)
      {
         return Convert.ToDouble(GetValue(i));
      }

      public Type GetFieldType(int i)
      {
         if (exposureEnumerator.Current == null) return null;

         switch (i)
         {
          case 0:
               return typeof(long);
            case 1:
               return typeof(long);
            case 2:
               return typeof(long);
            case 3:
               return typeof(DateTime);
            case 4:
               return typeof(string);
            case 5:
               return typeof(DateTime);
            case 6:
               return typeof(string);
            case 7:
               return typeof(DateTime?);
            case 8:
               return typeof(int?);
            case 9:
               return typeof(string);
            case 10:
               return typeof(int?);
            case 11:
               return typeof(decimal?);
            case 12:
               return typeof(int?);
            case 13:
               return typeof(string);
            case 14:
               return typeof(long);
            case 15:
               return typeof(string);
            case 16:
               return typeof(long?);
            case 17:
               return typeof(long?);
            case 18:
               return typeof(string);
            case 19:
               return typeof(long?);
            case 20:
               return typeof(string);
            case 21:
               return typeof(string);

            default:
               throw new NotImplementedException();
         }
      }

      public float GetFloat(int i)
      {
         return (float)GetValue(i);
      }

      public Guid GetGuid(int i)
      {
         return (Guid)GetValue(i);
      }

      public short GetInt16(int i)
      {
         return (short)GetValue(i);
      }

      public int GetInt32(int i)
      {
         return (int)GetValue(i);
      }

      public long GetInt64(int i)
      {
         return Convert.ToInt64(GetValue(i));
      }

      public int GetOrdinal(string name)
      {
         throw new NotImplementedException();
      }

      public string GetString(int i)
      {
         return (string)GetValue(i);
      }

      public int GetValues(object[] values)
      {
         throw new NotImplementedException();
      }

      public bool IsDBNull(int i)
      {
         return GetValue(i) == null;
      }

      public object this[string name]
      {
         get { throw new NotImplementedException(); }
      }

      public object this[int i]
      {
         get { throw new NotImplementedException(); }
      }
      #endregion
	}
}
