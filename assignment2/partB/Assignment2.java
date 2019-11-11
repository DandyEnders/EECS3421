import java.sql.*;

public class Assignment2 {
    
    // A connection to the database  
    Connection connection;
  
    // Statement to run queries
    Statement sql;
  
    // Prepared Statement
    PreparedStatement ps;
  
    // Resultset for the query
    ResultSet rs;
  
    //CONSTRUCTOR
    Assignment2(){
    }
  
    //Using the input parameters, establish a connection to be used for this session. Returns true if connection is sucessful
    public boolean connectDB(String URL, String username, String password){
        try {
		
 			// Load JDBC driver
			Class.forName("org.postgresql.Driver");
 
		} catch (ClassNotFoundException e) {
 
			//System.out.println("Where is your PostgreSQL JDBC Driver? Include in your library path!");
			//e.printStackTrace();
			return false;
 
		}

        System.out.println("PostgreSQL JDBC Driver Registered!");

        try {
			
 			//Make the connection to the database, ****** but replace <dbname>, <username>, <password> with your credentials ******
			//System.out.println("*** Please make sure to replace 'dbname', 'username' and 'password' with your credentials in the jdbc connection string!!!");
			connection = DriverManager.getConnection(URL + username, username, password);
 
		} catch (SQLException e) {
 
			//System.out.println("Connection Failed! Check output console");
			//e.printStackTrace();
			return false;
 
		}

        if (connection == null) {
            // System.out.println("Failed to make connection!");
            return false;
        }
 
        
        return false;
    }
  
    //Closes the connection. Returns true if closure was sucessful
    public boolean disconnectDB(){
        connection.close();
           if(connection.isClosed()){
        return true;
	}
        else {
        return false; 
	}     
    }
    
    public boolean insertPlayer(int pid, String pname, int globalRank, int cid) {
         try {
		
 			// Load JDBC driver
			Class.forName("org.postgresql.Driver");
        
            connection = DriverManager.getConnection("jdbc:postgresql://db:5432/<dbname>", "<username>", "<password>");
            
            
        
        //Create a Statement for executing SQL queries
			sql = connection.createStatement(); 
			
        String sqltext;
        
        sqltext = "INSERT INTO Player   " + 
                               "VALUES (4, 'Shane', 2, 4561)";
        System.out.println("Executing this command: \n" + sqlText.replaceAll("\\s+", " ") + "\n");
        sql.executeUpdate(sqltext); 
        connection.close(); 
	} catch (SQLException e) {

                        System.out.println("Query Exection Failed!");
                        e.printStackTrace();
                        return;
    }
  
    public int getChampions(int pid) {
	      return 0;  
    }
   
    public String getCourtInfo(int courtid){
        return "";
    }

    public boolean chgRecord(int pid, int year, int wins, int losses){
        return false;
    }

    public boolean deleteMatcBetween(int p1id, int p2id){
        return false;        
    }
  
    public String listPlayerRanking(){
	      return "";
    }
  
    public int findTriCircle(){
        return 0;
    }
    
    public boolean updateDB(){
	      return false;    
    }  
}
