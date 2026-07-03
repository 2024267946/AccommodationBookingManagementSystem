package DBConnection;

import java.sql.*;


public class DBConnection {
	static Connection con;
	//mysql
	//private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
	//private static final String DB_CONNECTION = "jdbc:mysql://localhost/plaza";
	//private static final String DB_USER = "root";
	//public static final String DB_PASSWORD = "";
	
	//oracle
	private static final String DB_DRIVER = "oracle.jdbc.driver.OracleDriver";
	private static final String DB_CONNECTION = "jdbc:oracle:thin:@//localhost:1521/freepdb1";
	private static final String DB_USER = "sinerrores"; 	
	public static final String DB_PASSWORD = "oracle";	
	
	public static Connection getConnection() {
		try {
			//1. load the driver
			Class.forName(DB_DRIVER);
			try {
				//2. create connection
				con = DriverManager.getConnection(DB_CONNECTION,DB_USER,DB_PASSWORD);
				System.out.println("Connected");
			}
			catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		catch  (ClassNotFoundException e) {
			System.out.println(e);
		}
		return con;
	}
}
