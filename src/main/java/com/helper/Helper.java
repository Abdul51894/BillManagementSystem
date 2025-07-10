package com.helper;

import java.sql.Connection;
import java.sql.DriverManager;

public class Helper {
	
	public static Connection helper() {
		
		Connection con = null;
		try{
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			 con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BillManagement","abdul","1243351894");
		}catch (Exception e) {
			e.printStackTrace();
		}
		return con;
	}
}