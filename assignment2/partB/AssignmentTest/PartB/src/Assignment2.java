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
    	try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {

		}
    }
  
    //Using the input parameters, establish a connection to be used for this session. Returns true if connection is sucessful
    public boolean connectDB(String URL, String username, String password){try {
        	connection = DriverManager.getConnection(URL + "/" + username, username, password);
			if (connection == null) {
	            return false;
	        }
			sql = connection.createStatement();
		} catch (SQLException e) {
			return false;
		}
        return true;
    }
  
    //Closes the connection. Returns true if closure was sucessful
    public boolean disconnectDB(){
    	try {
			connection.close();
			ps.close();
			rs.close();
		} catch (SQLException e) {
			return false;
		}
        return true;
    }
    
    private ResultSet sqlQuery(String sqlText) throws SQLException {
    	sqlText.replaceAll("\\s+", " ");
    	return sql.executeQuery(sqlText);
    }
    
    private void sqlUpdate(String sqlText) throws SQLException{
    	sqlText.replaceAll("\\s+", " ");
    	sql.executeUpdate(sqlText);
    }
    
    public boolean insertPlayer(int pid, String pname, int globalRank, int cid) {
    	try {
    		// Check if pid player exists
			rs = sqlQuery("SELECT pid FROM player WHERE player.pid = "+pid);
			if(rs.next()) {
				return false; // Player key exists
			}
			rs.close();

	    	String sqlText = String.format("INSERT INTO player VALUES (%d, '%s', %d, %d)", pid, pname, globalRank, cid);
			sqlUpdate(sqlText);

    	} catch (SQLException e) {
    		System.out.println("NO!");
    		e.printStackTrace();
    		return false;
		}
		return true;
    }
  
    public int getChampions(int pid) {
    	try {
			rs = sqlQuery("SELECT R.wins AS wins"
					+ "FROM record R JOIN champion C ON R.pid = C.pid"
					+ "WHERE R.pid = "+pid);
			rs.next();
			int wins = rs.getInt("wins");
			rs.close();
			return wins;
		} catch (SQLException e) {
			return -1;
		}
    }
   
    public String getCourtInfo(int courtid){
    	try {
			rs = sqlQuery("SELECT "
					+ "C.courtname AS courtname,"
					+ "C.capacity,"
					+ "T.tname AS tournamentname"
					+ "FROM court C JOIN tournament T ON C.tid = T.tid"
					+ "WHERE C.cid = " + courtid);
			if(rs.next()) {
				String courtname = rs.getString("courtname");
				int capacity = rs.getInt("capacity");
				String tname = rs.getString("tournamentname");
				
				String res = String.format("%s:%s:%d:%s", courtid, courtname, capacity, tname);
				
				rs.close();
				return res;
			}else{
				rs.close();
				return "";
			}
		} catch (SQLException e) {
			return "";
		}
    }

    public boolean chgRecord(int pid, int year, int wins, int losses){
        try {
        	String sqlText = "UPDATE record"
        			+ "SET"
        			+ "wins = " + wins + ","
        			+ "losses = " + losses
        			+ "WHERE"
        			+ "pid = " + pid + "AND"
        			+ "year = " + year;
			sqlUpdate(sqlText);
		} catch (SQLException e) {
			return false;
		}
        return true;
    }

    public boolean deleteMatcBetween(int p1id, int p2id){
    	try {
    		String sqlText = "DELETE FROM event"
        			+ "WHERE"
        			+ "(winid = " + p1id + " AND lossid = " + p2id + ") OR "
        			+ "(lossid = " + p1id + " AND winid = " + p2id + ")";
			sqlUpdate(sqlText);
		} catch (SQLException e) {
			return false;
		}
        return true;
    }
  
    public String listPlayerRanking(){
    	try {
        	String sqlText = "SELECT"
        			+ "pname, globalrank"
        			+ "FROM player"
        			+ "ORDER BY globalrank DESC";
			rs = sqlQuery(sqlText);
			
			rs.next();
			;
			String result = String.format("%s:%d", rs.getString("pname"), rs.getInt("globalrank"));
			while(rs.next()) {
				result = result.concat(String.format("\n%s:%d", rs.getString("pname"), rs.getInt("globalrank")));
			}
			rs.close();
			return result;
			
		} catch (SQLException e) {
			return "";
		}
    }
  
    public int findTriCircle(){
    	try {
			rs = sqlQuery("SELECT COUNT(*) AS num"
					+ "FROM event E1 "
					+ "JOIN event E2 ON E1.eid = E2.eid"
					+ "JOIN event E3 ON E1.eid = E3.eid"
					+ "WHERE"
					+ "E1.winid = E2.lossid AND"
					+ "E2.winid = E3.lossid AND"
					+ "E3.winid = E1.lossid");
			rs.next();
			int number = rs.getInt("num");
			rs.close();
			return number;
		} catch (SQLException e) {
			return -1;
		}
    }
    
    public boolean updateDB(){
    	try {
			sqlQuery("CREATE TABLE championPlayers("
					+ "pid INTEGER,"
					+ "pname VARCHAR,"
					+ "nchampions INTEGER"
					+ ")");
			sqlQuery("INSERT INTO championPlayers"
					+ "SELECT P.pid, P.pname, COUNT(year) AS nchampions"
					+ "FROM player P JOIN champion C ON P.pid = C.pid"
					+ "GROUP BY P.pid, P.pname"
					+ "HAVING COUNT(C.year) >= 1"
					+ "ORDER BY ASC");
		} catch (SQLException e) {
			return false;
		}
    	return true;    
    }  
}
