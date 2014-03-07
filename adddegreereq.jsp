<html>

<body>
  <table border="1">
    <tr>
      <td valign="top">
        <%-- -------- Include menu HTML code -------- --%>
        <jsp:include page="menu.html" />
      </td>
      <td>

      <%-- Set the scripting language to Java and --%>
      <%-- Import the java.sql package --%>
      <%@ page language="java" import="java.sql.*" %>
  
      <%-- -------- Open Connection Code -------- --%>
      <%
        try {
          Class.forName("org.postgresql.Driver"); 
          Connection conn = null;
          try {
          // Load Oracle Driver class file
           // (new com.microsoft.sqlserver.jdbc.SQLServerDriver());
          // Make a connection to the Oracle datasource "cse132b"
          //Connection conn = null;
          conn = DriverManager.getConnection
            ("jdbc:postgresql://localhost:8080/cse132b", 
              "sa", "123456");
          } catch (Exception e){
              try{
                  //Class.forName("org.postgresql.Driver"); 
                  // Make a connection to the Oracle datasource "cse132b"
                 conn = DriverManager.getConnection
                        ("jdbc:postgresql://localhost:5432/cse132b", 
                         "sa", "123456");
              } catch (Exception es){
                out.println(e.getMessage());
              }
          }

      %>

      <%-- -------- INSERT Code -------- --%>
      <%
          String action = request.getParameter("action");
          // Check if an insertion is requested
          if (action != null && action.equals("insert")) {

            // Begin transaction
            conn.setAutoCommit(false);
            
            // Create the prepared statement and use it to
            // INSERT the student attributes INTO the Student table.
            PreparedStatement pstmt = conn.prepareStatement(
              "INSERT INTO DEGREEREQ VALUES (?, ?, ?, ?)");

            pstmt.setString(1, request.getParameter("NAME"));
            pstmt.setString(2, request.getParameter("CAT"));
            pstmt.setInt(3, Integer.parseInt(request.getParameter("UREQ")));
            pstmt.setDouble(4, Double.parseDouble(request.getParameter("AVG_GPA")));
            int rowCount = pstmt.executeUpdate();

            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
          }
      %>


      <%-- -------- SELECT Statement Code -------- --%>
      <%
          // Create the statement
          Statement statement = conn.createStatement();

          // Use the created statement to SELECT
          // the student attributes FROM the Student table.
          ResultSet rs = statement.executeQuery
            ("SELECT * FROM DEGREEREQ");
      %>
        <h1>Add Degree Req</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>NAME OF DEGREE</th>
            <th>CATEGORY</th>
            <th>UNITS REQ</th>
						<th>AVG GPA</th>
            <th>Action</th>
          </tr>
          <tr>
            <form action="adddegreereq.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="NAME" size="25"></th>
              <th><input value="" name="CAT" size="15"></th>
              <th><input value="" name="UREQ" size="15"></th>
              <th><input value="" name="AVG_GPA" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( rs.next() ) {
    
      %>

          <tr>
            <form action="adddegreereq.jsp" method="get">
              <input type="hidden" value="update" name="action">

              <%-- Get the NAME --%>
              <td>
                <input value="<%= rs.getString("name_of_degree") %>" 
                  name="NAME" size="25">
              </td>
  
              <%-- Get the TYPE --%>
              <td>
                <input value="<%= rs.getString("category") %>" 
                  name="TYPE" size="15">
              </td>
  
              <%-- Get the UNITS REQ --%>
              <td>
                <input value="<%= rs.getInt("units_req") %>" 
                  name="UREQ" size="15">
              </td>
  
              <td>
                <input value="<%= rs.getDouble("avg_gpa") %>" 
                  name="AVG_GPA" size="15">
              </td>
            </form>
          </tr>
      <%
          }
      %>

      <%-- -------- Close Connection Code -------- --%>
      <%
          // Close the ResultSet
          rs.close();
  
          // Close the Statement
          statement.close();
  
          // Close the Connection
          conn.close();
        } catch (SQLException sqle) {
          out.println(sqle.getMessage());
        } catch (Exception e) {
          out.println(e.getMessage());
        }
      %>
        </table>
      </td>
    </tr>
  </table>
</body>

</html>
