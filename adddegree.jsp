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
              "INSERT INTO DEGREE VALUES (?, ?)");

            pstmt.setString(1, request.getParameter("NAME"));
            pstmt.setDouble(2, Double.parseDouble(request.getParameter("GPA")));
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
            ("SELECT * FROM DEGREE");
      %>
        <h1>Add Degree</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>NAME OF DEGREE</th>
            <th>AVERAGE GPA</th>
            <th>ACTION</th>
          </tr>
          <tr>
            <form action="adddegree.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="NAME" size="15"></th>
              <th><input value="" name="GPA" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- UPDATE Code -------- --%>
      <%
          // Check if an update is requested
          if (action != null && action.equals("update")) {

            // Begin transaction
            conn.setAutoCommit(false);
            
            // Create the prepared statement and use it to
            // UPDATE the student attributes in the Student table.
            PreparedStatement pstmt = conn.prepareStatement(
              "UPDATE Degree SET avg_gpa = ?, WHERE name_of_degree = ?");

            pstmt.setDouble(1, Double.parseDouble(request.getParameter("GPA")));
            pstmt.setString(2, request.getParameter("NAME"));
            int rowCount = pstmt.executeUpdate();

            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
          }
      %>

      <%-- -------- DELETE Code -------- --%>
      <%
          // Check if a delete is requested
          if (action != null && action.equals("delete")) {

            // Begin transaction
            conn.setAutoCommit(false);
            
            // Create the prepared statement and use it to
            // DELETE the student FROM the Student table.
            PreparedStatement pstmt = conn.prepareStatement(
              "DELETE FROM Degree WHERE name_of_degree = ?");

            pstmt.setString(
              1, request.getParameter("NAME"));
            int rowCount = pstmt.executeUpdate();

            // Commit transaction
             conn.commit();
            conn.setAutoCommit(true);
          }
      %>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( rs.next() ) {
    
      %>

          <tr>
            <form action="adddegree.jsp" method="get">
              <input type="hidden" value="update" name="action">

              <%-- Get the NAME --%>
              <td>
                <input value="<%= rs.getString("name_of_degree") %>" 
                  name="NAME" size="15">
              </td>

              <%-- Get the GPA --%>
              <td>
                <input value="<%= rs.getDouble("avg_gpa") %>" 
                  name="GPA" size="15">
              </td>
  
              <%-- Button --%>
              <td>
                <input type="submit" value="Update">
              </td>
            </form>
            <form action="adddegree.jsp" method="get">
              <input type="hidden" value="delete" name="action">
              <input type="hidden" 
                value="<%= rs.getString("name_of_degree") %>" name="NAME">
              <%-- Button --%>
              <td>
                <input type="submit" value="Delete">
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
