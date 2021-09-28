<style>
    @media screen and (min-width: 0px) and (max-width: 720px) {
        #datos_usuario2 { display: none; }.mobile-hide{ display: none; }
        
    }
    @media screen and (min-width: 720px)  {
        #datos_usuario3 { display: none; }.mobile-hide{ display: none; }
        
    }
    
</style>
<div class="col-12 col-lg-3 float-left" >
    <div  id="datos_usuario2" >
        <div id="opcionesMenu" class="card my-2" >

            <div id="header-card" class="card-header">
                <label for="nombre">Nombre:</label>
                <input id="nombre" class="form-control" type="text" value="<%=strNombreLegible%>" disabled="disabled" />
                <label for="email">E-mail:</label>
                <input id="email" class="form-control" type="text" value="<%=usuario%>" disabled="disabled" />

            </div>
            <ul id="menu-lateral" class="list-group">
                <li class="list-group-item list-group-item-action " title="Servicios Asignados en mi cuenta.">
                    <a href="<%=INICIO%>"><i class="fa fa-address-card-o" aria-hidden="true"></i> Servicios Asignados</a>
                </li>
                <li class="list-group-item list-group-item-action " title="Agregar un nuevo servicio a mi cuenta.">
                    <a href="AgregarServicio.jsp"><i class="fa fa-plus" aria-hidden="true"></i> Agregar Servicio</a>
                </li>
                <li class="list-group-item list-group-item-action"title="Notificar mis Alertas por Correo.">
                    <a href="ServiciosAlertas.jsp"><i class="fa fa-bell-o" aria-hidden="true"></i> Servicios de Alertas</a>
                </li>
                <li class="list-group-item list-group-item-action"title="Carta de no Adeudo">
                    <a href="Cna.jsp"><i class="fa fa-bell-o" aria-hidden="true"></i>Carta de No Adeudo</a>
                </li>
                <li class="list-group-item list-group-item-action" title="Modificar mi Información">
                    <a href="UserEdit.jsp"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Modificar Datos</a>
                </li>
                <li class="list-group-item list-group-item-action" title="Genera reportes operativos">
                    <a href="Reportes.jsp"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Reportes</a>
                </li>
                <li class="list-group-item list-group-item-action" title="Cerrar mi Sesión.">
                    <form action="cerrarsesion"   method="post" id="formsalir" name="formsalir" >
                        <a onclick="cerrarsesion()"><i class="fa fa-sign-out" aria-hidden="true"></i> Cerrar Sesión</a>
                    </form>
                    <script>
                        function cerrarsesion() {
                            $("#formsalir").submit();
                        }
                    </script>
                </li></ul>

        </div>
    </div>
    <div id="datos_usuario3"  >
        <nav class="navbar navbar-expand-sm navbar-light bg-light">
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#opciones">
      <span class="navbar-toggler-icon"></span>
    </button>
    
    
    <!-- enlaces -->
    <div class="collapse navbar-collapse" id="opciones">   
      <ul class="navbar-nav">
        <li class="nav-item">
         <a class="nav-link" href="<%=INICIO%>">Servicios Asignados</a>
        </li>
        <li class="nav-item">
         <a class="nav-link"  href="AgregarServicio.jsp">Agregar Servicio</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="ServiciosAlertas.jsp"> Servicios de Alertas</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="Cna.jsp"> Carta de No Adeudo</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="UserEdit.jsp"> Modificar Datos</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="Reportes.jsp">Reportes</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="cerrarsesion">Cerrar Sesión</a>
        </li>
      </ul>
    </div>
  </nav>
    </div>

</div>
