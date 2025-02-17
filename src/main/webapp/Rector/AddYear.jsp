<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.mysql.cj.xdevapi.Statement"%>
<%@page import="com.gatePass.helper.ConnectionProvider"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Bootstrap demo</title>
<jsp:include page="../Components/Header.jsp"></jsp:include>
</head>
<body>
	<jsp:include page="../Components/NavBar.jsp"></jsp:include>

	<div class="container">
		<div class="row">
			<div class="col-sm-2"></div>
			<div class="col-sm-8 mt-5 p-2">
				<form action="DB/AddBranchDB.jsp" id="addClass">
					<h1>Add Year</h1>
					<div class="mb-3">
						<label for="exampleInput" class="form-label">Enter Year</label> <input
							type="text" class="form-control" id="exampleInput"
							aria-describedby="textHelp" name="yearName" />
					</div>

					<button 
					type="submit" 
					class="btn btn-primary px-4" 
					id="year-submit-btn"
					
					>Submit</button>
					<button type="button" class="btn btn-danger" id="cancleBtn"
						style="display: none">Cancel</button>
				</form>
			</div>
		</div>
	</div>

	<div class="container mt-5">
		<div class="row">
			<div class="col-lg-3"></div>
			<div class="col-lg-6">
				<h2>Year List</h2>
				<table class="table table-bordered">
					<thead>
						<tr>
							<th scope="col">Sr .</th>
							<th scope="col">Class</th>
							<th scope="col" style="vertical-align: bottom;">Operation</th>

						</tr>
					</thead>
					<tbody>
						<%
						Connection con = ConnectionProvider.getConnection();
						PreparedStatement stmt = con.prepareStatement("select * from acc_year");
						ResultSet rs = stmt.executeQuery();
						while (rs.next()) {
						%>
						<tr>
							<th scope="row"><%=rs.getString("id")%></th>
							<td><%=rs.getString("year_name")%></td>
							<td><button 
							type="button" class="btn btn-outline-warning"
							onclick="updateYear(<%=rs.getString("id")%>,'<%=rs.getString("year_name")%>')">Update</button>
								&nbsp &nbsp
								<button type="button" class="btn btn-outline-danger"
									onclick="deleteYear(<%=rs.getString("id")%>,'<%=rs.getString("year_name")%>')"
									id="deleteBranch">Delete</button></td>
						</tr>

						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.1/dist/sweetalert2.all.min.js"></script>

	<script type="text/javascript">
	
	
	
	const cancelBtn = document.querySelector("#cancleBtn");
	const inputYear = document.querySelector("#exampleInput");
	const submitBtn = document.querySelector("#year-submit-btn");
	let requestUrl = "DB/AddYearDB.jsp";
	
	cancelBtn.addEventListener("click",(e)=>{
		e.preventDefault();
		cancelBtn.style.display = "none"
		submitBtn.className = "btn btn-primary px-4"
		submitBtn.innerHTML = "Add Year"
		requestUrl = "DB/AddYearDB.jsp";
		inputYear.value = ""
	})	
	
	function updateYear(yearId,yearName){
		submitBtn.className = "btn btn-success"
		submitBtn.innerHTML = "Update Year"
		inputYear.value = yearName
		cancelBtn.style.display = "inline-block"
		requestUrl = "DB/UpdateYearDB.jsp?yearId=" + yearId;
		inputYear.focus()
	}
	
      $(document).ready(function () {
        $("#addClass").submit(function (e) {
          e.preventDefault();
          $.ajax({
            type: "POST",
            url: requestUrl,
            data: $("#addClass").serialize(),
            success: function (response) {
            	console.log(" ==> ",response.trim())
              if (response.trim()[0] === "1") {
                Swal.fire({
                  title: "Year "+ response.trim().slice(1) + " Successfully",
                  text: "Click OK to continue!",
                  icon: "success",
                }).then((res) => {
                  window.location.reload();
                });
              } else {
                Swal.fire({
                  icon: "error",
                  title: "Oops...",
                  text: "Something went wrong!",
                });
              }
            },
          });
        });
      });
      
      
      
	    function deleteYear(yearId,yearName){
			Swal.fire({
	            icon: "warning",
				  title: "Are you sure !!?",
				  text:"DELETE (" + yearName + "Branch !!)",
				  showDenyButton: true,
				  confirmButtonText: "Yes",
				  denyButtonText: `Cancel`
				}).then((result) => {
				  if (result.isConfirmed) {
					  $.ajax({
					        url: "DB/DeleteYear.jsp",
					        type: "POST",
					        data: {yearId},
					        success: function(response) {
					              if (response.trim() === "1") {
					                  Swal.fire({
					                    title: "Branch Deleted Successfully",
					                    text: "Click OK to continue!",
					                    icon: "success",
					                  }).then((res) => {
					                    window.location.reload();
					                  });
					                } else {
					                  Swal.fire({
					                    icon: "error",
					                    title: "Oops...",
					                    text: "Something went wrong!",
					                  });
					                }
					              },
					        error: function(xhr, status, error) {
					          console.log("Error:", error);
					        }
					      });
				  } else if (result.isDenied) {
				    Swal.fire("Branch Not Deleted", "", "info");
				  }
				});
		}
      
    </script>

	<jsp:include page="../Components/Footer.jsp"></jsp:include>
</body>
</html>
