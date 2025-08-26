package com.helper;

import java.sql.Connection;
import java.sql.DriverManager;

public class Helper {
	
	public static Connection helper() {
		
		Connection con = null;
		try{
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			 con = DriverManager.getConnection("jdbc:mysql://switchback.proxy.rlwy.net:34435/railway","root","kJvdDQopAWrgSJBjXcMaLDawpSFjnGFD");
		}catch (Exception e) {
			e.printStackTrace();
		}
		return con;
	}
}