<%@page import="com.ayd.dto.eAydObjLst"%>
<%@page import="com.ayd.dao.SwitchLoginDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
        <link href="imagenes/logo_transp.gif" rel="shortcut icon" type="image/x-icon" />
        <link href="imagenes/logo_transp.gif" rel="apple-touch-icon" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Switch de Login</title>
    </head>
    <body>
        <%
            SwitchLoginDTO sg = new SwitchLoginDTO();
            if (null==sg.getDetenerLogin()||sg.getDetenerLogin().equalsIgnoreCase("false")) {
        %>

        <div class="alert alert-success" role="alert">
               <form action="switchlogin"  method="POST" >
            <h1>Switch Login: <%=sg.getDetenerLogin() %></h1> 
            <h1>Fecha falla en lista: <%=sg.getFchStop()%></h1> 
         
            <button type="submit" id="switch" onclick="document.getElementById('switch').hidden=true"  class="btn btn-outline-success">Activar</button>
            <input name="switch"  value="false" hidden/>
            </form>
        </div>
        <%
        } else {
        %>
        <div class="alert alert-warning" role="alert">
            <form action="switchlogin" method="POST" >
            <h1>Switch Login: <%=sg.getDetenerLogin()%></h1> 
            <h1>Fecha falla en lista: <%=sg.getFchStop()%></h1> 
            <button type="submit"  id="switch" onclick="document.getElementById('switch').hidden=true" class="btn btn-outline-success">Desactivar</button>
            <input name="switch" value="true" hidden/>
            </form>
        </div>
        <%
            }
        %>
         <div class="alert alert-primary" role="alert">
            <form action="listdelete" method="POST" >
            <h1>Switch Lista de referencias: <%=eAydObjLst.lstDTO.size()%></h1> 
            <h1>Fecha falla en lista: <%=sg.getFchStop()%></h1>
            <input name="swa" value="swa" hidden >
            <%if(!eAydObjLst.lstDTO.isEmpty()){%>
             <button type="submit"  id="lista" class="btn btn-outline-success">Limpiar</button>
            <%}%>
           
            
            </form>
        </div>
        
    </body>
</html>
