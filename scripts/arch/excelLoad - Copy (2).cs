#region Help:  Introduction to the script task
/* The Script Task allows you to perform virtually any operation that can be accomplished in
 * a .Net application within the context of an Integration Services control flow. 
 * 
 * Expand the other regions which have "Help" prefixes for examples of specific ways to use
 * Integration Services features within this script task. */
#endregion


#region Namespaces
using System;
using System.Data;
using Microsoft.SqlServer.Dts.Runtime;
using System.Windows.Forms;
using System.IO;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Diagnostics;
#endregion

namespace ST_88386af6377947708c61e5210634026a
{
    /// <summary>
    /// ScriptMain is the entry point class of the script.  Do not change the name, attributes,
    /// or parent of this class.
    /// </summary>
	[Microsoft.SqlServer.Dts.Tasks.ScriptTask.SSISScriptTaskEntryPointAttribute]
    public partial class ScriptMain : Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase
    {
        #region Help:  Using Integration Services variables and parameters in a script
        /* To use a variable in this script, first ensure that the variable has been added to 
         * either the list contained in the ReadOnlyVariables property or the list contained in 
         * the ReadWriteVariables property of this script task, according to whether or not your
         * code needs to write to the variable.  To add the variable, save this script, close this instance of
         * Visual Studio, and update the ReadOnlyVariables and 
         * ReadWriteVariables properties in the Script Transformation Editor window.
         * To use a parameter in this script, follow the same steps. Parameters are always read-only.
         * 
         * Example of reading from a variable:
         *  DateTime startTime = (DateTime) Dts.Variables["System::StartTime"].Value;
         * 
         * Example of writing to a variable:
         *  Dts.Variables["User::myStringVariable"].Value = "new value";
         * 
         * Example of reading from a package parameter:
         *  int batchId = (int) Dts.Variables["$Package::batchId"].Value;
         *  
         * Example of reading from a project parameter:
         *  int batchId = (int) Dts.Variables["$Project::batchId"].Value;
         * 
         * Example of reading from a sensitive project parameter:
         *  int batchId = (int) Dts.Variables["$Project::batchId"].GetSensitiveValue();
         * */

        #endregion

        #region Help:  Firing Integration Services events from a script
        /* This script task can fire events for logging purposes.
         * 
         * Example of firing an error event:
         *  Dts.Events.FireError(18, "Process Values", "Bad value", "", 0);
         * 
         * Example of firing an information event:
         *  Dts.Events.FireInformation(3, "Process Values", "Processing has started", "", 0, ref fireAgain)
         * 
         * Example of firing a warning event:
         *  Dts.Events.FireWarning(14, "Process Values", "No values received for input", "", 0);
         * */
        #endregion

        #region Help:  Using Integration Services connection managers in a script
        /* Some types of connection managers can be used in this script task.  See the topic 
         * "Working with Connection Managers Programatically" for details.
         * 
         * Example of using an ADO.Net connection manager:
         *  object rawConnection = Dts.Connections["Sales DB"].AcquireConnection(Dts.Transaction);
         *  SqlConnection myADONETConnection = (SqlConnection)rawConnection;
         *  //Use the connection in some code here, then release the connection
         *  Dts.Connections["Sales DB"].ReleaseConnection(rawConnection);
         *
         * Example of using a File connection manager
         *  object rawConnection = Dts.Connections["Prices.zip"].AcquireConnection(Dts.Transaction);
         *  string filePath = (string)rawConnection;
         *  //Use the connection in some code here, then release the connection
         *  Dts.Connections["Prices.zip"].ReleaseConnection(rawConnection);
         * */
        #endregion


        /// <summary>
        /// This method is called when this script task executes in the control flow.
        /// Before returning from this method, set the value of Dts.TaskResult to indicate success or failure.
        /// To open Help, press F1.
        /// </summary>
        public void Main()
        {
            // TODO: Add your code here
            String FolderPath = Dts.Variables["User::FolderPath"].Value.ToString();
            String TableName = Dts.Variables["User::TableName"].Value.ToString();
            var directory = new DirectoryInfo(FolderPath);
            FileInfo[] files = directory.GetFiles();

            //Declare and initilize variables
            string fileFullPath = "";

            //Get one Book(Excel file at a time)
            foreach (FileInfo file in files)
            {

                fileFullPath = FolderPath + "\\" + file.Name;

                //Create Excel Connection
                string ConStr;
                string HDR;
                HDR = "NO";
                ConStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fileFullPath + ";Extended Properties=\"Excel 12.0;HDR=" + HDR + ";IMEX=1\"";
                OleDbConnection cnn = new OleDbConnection(ConStr);



                //Get Sheet Name
                cnn.Open();
                DataTable dtSheet = cnn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                string sheetname;
                sheetname = "";
                foreach (DataRow drSheet in dtSheet.Rows)
                {

                    sheetname = drSheet["TABLE_NAME"].ToString();

                }

                //Load the DataTable with Sheet Data
                OleDbCommand oconn = new OleDbCommand("select * from [" + sheetname + "]", cnn);
                OleDbDataAdapter adp = new OleDbDataAdapter(oconn);
                DataTable dt = new DataTable();
                adp.Fill(dt);
                cnn.Close();

                /////////////////////////////////////////
                // TODO edit datatable or create new one.

                DataTable clearData = new DataTable();
                clearData.Columns.Add("Make_name");
                clearData.Columns.Add("Make_guid");
                clearData.Columns.Add("Product_Model_Name");
                clearData.Columns.Add("Model_guid");
                clearData.Columns.Add("Model_Specifications_1");
                clearData.Columns.Add("Model_Specifications_2");
                clearData.Columns.Add("Quantity");
                clearData.Columns.Add("Unit_Price");
                DataRow row;

                int i = 0; //row in sourse dt
                int j = 1; //column in sourse dt
                int jj; //to keep column index from sourse dt
                int r = 0; //row in target dt
                int c = 0; //row in target dt
                int cc; //to keep column index from target dt

                Debug.WriteLine(dt.Rows[i][0]);
                Debug.WriteLine(dt.Rows[10][0]);
                Debug.WriteLine(dt.Rows[10][2]);

                // find dataset start cell
                while (dt.Rows[i][0] != DBNull.Value )
                {
                    i++;
                }
                i++;
                while (dt.Rows[i][0] != DBNull.Value)
                {
                    i++;
                }
                i++;
                while (dt.Rows[i][j] != DBNull.Value)
                {
                    j++;
                }
                j++;
                i++;

                // copy needed dataset to datatable
                while (dt.Rows[i][j] != DBNull.Value)
                {
                    jj = j;
                    cc = c;
                    for (c = 0; c < clearData.Columns.Count; c++)
                    {
                        
                        row = clearData.NewRow();
                        clearData.Rows.Add(row);
                        clearData.Rows[r][c] = dt.Rows[i][j];
                        jj++;
                        cc++;
                    }
                    i++;
                    r++;
                }






                //Use the ADO.NET connection and Load the data from DataTable to SQL Table
                SqlConnection myADONETConnection = new SqlConnection();
                myADONETConnection = (SqlConnection)(Dts.Connections["T21"].AcquireConnection(Dts.Transaction) as SqlConnection);

                //MessageBox.Show(myADONETConnection.ConnectionString, "ADO.NET Connection");
                using (SqlBulkCopy BC = new SqlBulkCopy(myADONETConnection))
                {
                    BC.DestinationTableName = TableName;
                    //use when you will have appropriate column names
                    //foreach (var column in dt.Columns)
                    //    BC.ColumnMappings.Add(column.ToString(), column.ToString());
                    BC.WriteToServer(clearData);
                }

            }

            Dts.TaskResult = (int)ScriptResults.Success;
        }

        #region ScriptResults declaration
        /// <summary>
        /// This enum provides a convenient shorthand within the scope of this class for setting the
        /// result of the script.
        /// 
        /// This code was generated automatically.
        /// </summary>
        enum ScriptResults
        {
            Success = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Success,
            Failure = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Failure
        };
        #endregion

    }
}