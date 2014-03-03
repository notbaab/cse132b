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
              "INSERT INTO faculty VALUES (?, ?, ?, ?, ?)");

            pstmt.setString(1, request.getParameter("FIRST"));
            pstmt.setString(2, request.getParameter("MIDDLE"));
            pstmt.setString(3, request.getParameter("LAST"));
             pstmt.setString(4, request.getParameter("TITLE"));
            pstmt.setString(5, request.getParameter("DEPARTMENT"));
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
              "DELETE FROM faculty WHERE fac_fname = ? AND fac_lname = ?");

            pstmt.setInt(
              1, Integer.parseInt(request.getParameter("FIRST")));
            pstmt.setInt(
              2, Integer.parseInt(request.getParameter("LAST")));
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
            ("SELECT * FROM faculty");
      %>
        <h1>Add a Faculty</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>FIRST</th>
            <th>MIDDLE</th>
            <th>LAST</th>
            <th>TITLE</th>
            <th>DEPARTMENT</th>
            <th>ACTION</th>
          </tr>
          <tr>
            <form action="faculty.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="FIRST" size="15"></th>
              <th><input value="" name="MIDDLE" size="15"></th>
              <th><input value="" name="LAST" size="15"></th>
        <th><input value="" name="TITLE" size="15"></th>
              <th><input value="" name="DEPARTMENT" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( rs.next() ) {
    
      %>

          <tr>
            <form action="faculty.jsp" method="get">
              <input type="hidden" value="update" name="action">

              <%-- Get the FIRST --%>
              <td>
                <input value="<%= rs.getString("fac_fname") %>" 
                  name="FIRST" size="15">
              </td>
  
              <%-- Get the MIDDLE --%>
              <td>
                <input value="<%= rs.getString("fac_mname") %>" 
                  name="MIDDLE" size="15">
              </td>
  
              <%-- Get the LAST --%>
              <td>
                <input value="<%= rs.getString("fac_lname") %>"
                  name="LAST" size="15">
              </td>
  
              <%-- Get the TITLE --%>
              <td>
                <input value="<%= rs.getString("f_title") %>" 
                  name="TITLE" size="15">
              </td>
  
              <%-- Get the DEPARTMENT --%>
              <td>
                <input value="<%= rs.getString("d_name") %>" 
                  name="DEPARTMENT" size="15">
              </td>
  
              <%-- Button --%>
              <td>
                <input type="submit" value="Update">
              </td>
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
