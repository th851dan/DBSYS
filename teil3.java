package dbsys;
import java.sql.*;
import java.io.*;
public class teil3 {

	public static void main(String[] args) {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rset = null;
		BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
		String name = null;
		String passwd = null;
		String land = null;
		Date an = null;
		Date ab = null;
		String aus = null;
		
		try {
			System.out.println("Benutzername: ");
			name = in.readLine();
			System.out.println("Passwort:");
			passwd = in.readLine();
		} catch (IOException e) {
			System.out.println("Fehler beim Lesen der Eingabe: " + e);
			System.exit(-1);
		}

		System.out.println("");
		
		System.out.println("Suchen nach Ferienwohnung!!");
		try {
			System.out.println("Gewünschtes Land: ");
			land = in.readLine();
			System.out.println("Von wann(YYYY_MM_DD): ");
			an = Date.valueOf(in.readLine());
			System.out.println("Bis wann(YYYY_MM_DD): ");
			ab = Date.valueOf(in.readLine());
			System.out.println("Gewünschte Ausstattung(Optional): ");
			aus = in.readLine();
			if (aus.length() == 0)
				aus = "ANY(SELECT aus_Name FROM wa)";
			else
				aus = "'" + aus + "'";
		} catch (IOException e) {
			System.out.println("Fehler beim Lesen der Eingabe: " + e);
			System.exit(-1);
		}
		
		try {
			DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
			String url = "jdbc:oracle:thin:@oracle12c.in.htwg-konstanz.de:1521:ora12c"; // String für DB-Connection
			conn = DriverManager.getConnection(url, name, passwd);
			
			conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); 			// Transaction Isolations-Level setzen
			conn.setAutoCommit(false);													// Kein automatisches Commit
			stmt = conn.createStatement();
			stmt.execute("alter session set NLS_DATE_FORMAT='YYYY-MM-DD'");
			fwsuchen(land, an, ab, aus, stmt, rset);
//			String mySelectquery = "SELECT f.fw_Name , AVG(b.buc_Sterne) as Bewertung\r\n" + 
//					"FROM dbsys13.Fw f LEFT OUTER JOIN dbsys13.Buchung b ON f.fw_Name = b.fw_Fwn INNER JOIN dbsys13.wa ON f.fw_Name = wa.fw_Fwn\r\n" + 
//					"WHERE f.fw_Name != ANY(SELECT fw_Fwn FROM dbsys13.Buchung b\r\n" + 
//					"                        WHERE (b.buc_von BETWEEN '"+ an + "' AND '" + ab + "') OR (b.buc_bis BETWEEN '" + an + "' AND '" + ab +"') OR (b.buc_von < '" + an +"' AND b.buc_bis > '" + ab +"'))\r\n" + 
//					"AND wa.aus_Name = " + aus + " AND f.im_land = '" + land + "' \r\n" + 
//					"GROUP BY f.fw_Name\r\n" + 
//					"ORDER BY Bewertung DESC";
//			System.out.println(mySelectquery);
//			rset = stmt.executeQuery(mySelectquery);
//			System.out.println("Fw   "  + "Bewertung");
//			while (rset.next()) {
//				String fw = rset.getString("fw_name");
//				double bw = rset.getDouble("Bewertung");
//				System.out.print(fw + "   ");
//				if (bw == 0.0)
//					System.out.println("null");
//				else
//					System.out.println(bw);
//			}
			rset.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			System.out.println();
			System.out
			.println("SQL Exception occurred while establishing connection to DBS: "
					+ e.getMessage());
			System.out.println("- SQL state  : " + e.getSQLState());
			System.out.println("- Message    : " + e.getMessage());
			System.out.println("- Vendor code: " + e.getErrorCode());
			System.out.println();
			System.out.println("EXITING WITH FAILURE ... !!!");
			System.out.println();
			try {
				conn.rollback();														// Rollback durchführen
			} catch (SQLException se) {
				se.printStackTrace();
			}
			System.exit(-1);
		} 				// Treiber laden
	}

	private static void fwsuchen(String land, Date an, Date ab, String aus, Statement stmt, ResultSet rset) {
		String mySelectquery = "SELECT f.fw_Name , AVG(b.buc_Sterne) as Bewertung\r\n" + 
				"FROM dbsys13.Fw f LEFT OUTER JOIN dbsys13.Buchung b ON f.fw_Name = b.fw_Fwn INNER JOIN dbsys13.wa ON f.fw_Name = wa.fw_Fwn\r\n" + 
				"WHERE f.fw_Name != ANY(SELECT fw_Fwn FROM dbsys13.Buchung b\r\n" + 
				"                        WHERE (b.buc_von BETWEEN '"+ an + "' AND '" + ab + "') OR (b.buc_bis BETWEEN '" + an + "' AND '" + ab +"') OR (b.buc_von < '" + an +"' AND b.buc_bis > '" + ab +"'))\r\n" + 
				"AND wa.aus_Name = " + aus + " AND f.im_land = '" + land + "' \r\n" + 
				"GROUP BY f.fw_Name\r\n" + 
				"ORDER BY Bewertung DESC";
		System.out.println(mySelectquery);
		try {
			rset = stmt.executeQuery(mySelectquery);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("Fw   "  + "Bewertung");
		try {
			while (rset.next()) {
				String fw = rset.getString("fw_name");
				double bw = rset.getDouble("Bewertung");
				System.out.print(fw + "   ");
				if (bw == 0.0)
					System.out.println("null");
				else
					System.out.println(bw);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
