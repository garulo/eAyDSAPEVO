<style>
    a{
        text-decoration: none !important;
    }
    a:hover{
        text-decoration: none !important;
    }
</style>
<script>
var lastScrollTop = 0;
$(window).scroll(function(event){
   var st = $(this).scrollTop();
   if (st > lastScrollTop){
       // downscroll code
       document.getElementById("TopMenu").style.display = "none"
   } else {
      // upscroll code
      document.getElementById("TopMenu").style.display = "inline"
   }
   lastScrollTop = st;
});
</script>

<div  data-ix="move-down-on-load" id="TopMenu" data-w-id="151ec016-beb1-b657-3bb7-0a531105cafe" class="top-bar" style="opacity: 1; transform: translateX(0px) translateY(0%) translateZ(0px); transition: opacity 200ms ease 0s, transform 800ms ease 0s;">
    <div data-collapse="medium" data-animation="default" data-duration="400" id="Top" class="navbar-1 w-nav">
        <div class="content-wrapper w-container">
            <script>
                function logoref() {
                    top.location.href = "https://web.sadm.gob.mx/";
                }
            </script>
            <a onclick="logoref()" data-ix="fade-out-on-click" class="brand w-nav-brand w--current">
                <img src="images/AYD.png" srcset="https://uploads-ssl.webflow.com/5ad759a356a64144486fd75f/5b6b5f504c3819038b156e33_logo%20sadm-p-500.png 500w, https://uploads-ssl.webflow.com/5ad759a356a64144486fd75f/5b6b5f504c3819038b156e33_logo%20sadm-p-800.png 800w, https://uploads-ssl.webflow.com/5ad759a356a64144486fd75f/5b6b5f504c3819038b156e33_logo%20sadm-p-1080.png 1080w, https://uploads-ssl.webflow.com/5ad759a356a64144486fd75f/5b6b5f504c3819038b156e33_logo%20sadm.png 1217w" sizes="(max-width: 479px) 79vw, (max-width: 767px) 192px, 202px">
            </a>
            <nav role="navigation" class="w-nav-menu">
                <a id="inicio" onclick="inicioref()" data-ix="fade-out-on-click" class="navlink w-nav-link" style="max-width: 1170px;">
                    <script>
                        function inicioref() {
                            top.location.href = "https://web.sadm.gob.mx/";
                        }
                    </script>
                    Inicio
                </a>
                <a id="consulta-en-linea" onclick="consultaref()"  data-ix="fade-out-on-click" class="navlink w-nav-link" style="max-width: 1170px;">
                    <script>
                        function consultaref() {
                            top.location.href = "https://ayd.sadm.gob.mx/eAyd/";
                        }
                    </script>
                    Consulta en Línea
                </a>                        
                <a id="pago-en-linea" onclick="pagoref()" data-ix="fade-out-on-click" class="navlink w-nav-link" style="max-width: 1170px;">
                    <script>
                        function pagoref() {
                            top.location.href = "https://ayd.sadm.gob.mx/eAyd/";
                        }
                    </script>
                    Pago en Línea
                </a>
                <a id="factibilidades" onclick="factibilidadesref()" data-ix="fade-out-on-click" class="navlink w-nav-link" style="max-width: 1170px;">
                    <script>
                        function factibilidadesref() {
                            top.location.href = "https://ayd.sadm.gob.mx/eClickEnLinea/";
                        }
                    </script>
                    Factibilidades
                </a>      

            </nav>
            <div class="menu-button w-nav-button">
                <div>
                    <div class="line-1"></div>
                    <div class="line-2"></div>
                    <div class="line-3"></div>
                </div>
            </div>

        </div>
        <div class="w-nav-overlay" data-wf-ignore=""></div>
    </div>
<br></div>
