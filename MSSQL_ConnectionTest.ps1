$SQLServer = "103.21.58.193"
$SQLDBName = "recruithealthpur"
$uid ="nodalrecruit"
$pwd = ""
$SqlQuery = "SELECT * from [dbo].[post_name];"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Data Source = $SQLServer; Database = $SQLDBName; Integrated Security = False; User ID = $uid; Password = $pwd;"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)

$DataSet.Tables[0]