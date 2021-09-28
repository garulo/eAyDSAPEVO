NS4=(document.layers) ;

NS60=(navigator.userAgent.indexOf("Netscape6/6.0")!=-1);

Opera=(navigator.userAgent.indexOf('Opera')!=-1)||(navigator.appName.indexOf('Opera')!=-1)||(window.opera);

Opera7=(Opera&&document.createElement!=null&&document.addEventListener!=null);

IE4=(document.all&&!Opera) ;

mac=((IE4)&&(navigator.appVersion.indexOf ("Mac")!=-1));

DOM=document.documentElement&&!NS4&&!IE4&&!Opera;

mswnd=(navigator.appVersion.indexOf("Windows")!=-1||navigator.appVersion.indexOf("WinNT")!=-1);



if(IE4)

{

	av=navigator.appVersion;

	avi=av.indexOf("MSIE");

	if (avi==-1){version = parseInt (av);}else {version=parseInt(av.substr(avi+4));}

}

var ver='6.1.2EnPro';

var m1=new Object;

m1.name='m1';

if(!window.lastm||window.lastm<1)lastm=1;

if(NS4||IE4||DOM||Opera)

{

m1.activePopup=null;

m1.activePopupTimeout='';

var maxZ=1000;

m1.popupFrame;

m1.targetFrame;

var docLoaded=false;

m1.bIncBorder=true;

m1.scrollTimeout=null;

m1.scrollTimeoutStr='';

m1.scrollDelay=50;

m1.scrollStep=10;

m1.showDelayedTimeout=null;

m1.fadingSteps=10;

m1.imgFolder = "menus/";

m1.maxlev = 2;

m1.popAlign = 0;

m1.bVarWidth = 1;

m1.bShowDel = 0;

m1.popupWidth = 150;

m1.levelOffset = 20;

m1.bord = 6;

m1.vertSpace = 2;

m1.sep = 1;

m1.sepFrame = false;

m1.openSameFrame = false;

m1.cntFrame = "content";

m1.contentFrame = "content";

m1.mout = true;

m1.iconSize = 8;

m1.closeDelay = 800;

m1.tlmOrigBg = "";

m1.tlmOrigCol = "Black";

m1.bBitmapScheme = true;

m1.popupOpacity = 90;

m1.bBitmapPopups = true;

if(document.getElementById&&(!Opera||Opera7))m1.bord=0;

m1.popupOpenHeight = 5;

m1.popupLeftPad = 3;

m1.popupRightPad = 3;

m1.tlmHlBg = "white";

m1.tlmHlCol = "blue";

m1.borderCol = "Black";

m1.menuHorizontal = true;

m1.scrollHeight=6;

}



m1.lev0 = new Array ("11px",false,false,"Black","white","blue","Arial,Verdana,Tahoma","#DADBF1") ;

m1.lev1 = new Array ("11px",false,false,"Black","white","blue","Arial,Verdana,Tahoma","#DADBF1") ;

m1.lev2 = new Array ("11px",false,false,"Black","white","blue","Arial,Verdana,Tahoma","#DADBF1") ;



m1mn1 = new Array

(

"Antecedentes","http://ayd.sadm.gob.mx/antecedentes.html",0

,"Misión - Visión","http://ayd.sadm.gob.mx/mision.html",0

,"Funciones","http://ayd.sadm.gob.mx/funciones.html",0

,"Estructura Orgánica","http://ayd.sadm.gob.mx/estructura.html",0

,"Directorio","http://ayd.sadm.gob.mx/directorio.html",0

//,"Marco Legal","http://www.sadm.gob.mx/marco_legal.html",0

,"Proyectos","http://www.sadm.gob.mx/principales_proyectos.html",0

)





m1mn2 = new Array

(

"Usuarios Domésticos","http://www.sadm.gob.mx/domesticos.html",0

,"Usuarios Comercial","http://www.sadm.gob.mx/comercial.html",0

,"Usuarios Industrial","http://www.sadm.gob.mx/comercial.html",0

,"Laboratorios","http://www.sadm.gob.mx/laboratorios.html",0

,"Otros","http://www.sadm.gob.mx/otros.html",0

)





m1mn2_1 = new Array

(

"Requisitos para contratación","#",0

,"Donde realizar su trámite","#",0

,"Tiempos","#",0

)





m1mn2_2 = new Array

(

"Requisitos para contratación","#",0

,"Donde realizar su trámite","#",0

,"Tiempos","#",0

)





m1mn2_3 = new Array

(

"Requisitos para contratación","#",0

,"Donde realizar su trámite","#",0

,"Tiempos","#",0

)





m1mn2_4 = new Array

(

"Requisitos para contratación","#",0

,"Donde realizar su trámite","#",0

,"Tiempos","#",0

)





m1mn2_5 = new Array

(

"Requisitos para contratación","#",0

,"Donde realizar su trámite","#",0

,"Tiempos","#",0

)







m1mn3 = new Array

(

"Dónde Pagar","http://www.sadm.gob.mx/donde_pagar.html",0

,"Pago en Línea","https://www.sadm.gob.mx/ayd/Login.jsp",0

,"Como Leer su Medidor","http://www.sadm.gob.mx/medidor.html",0

,"Tarifas","http://www.sadm.gob.mx/tarifas/tarifa.php",0

)





m1mn5 = new Array

(

"Saneamiento","#",1

,"Ingeniería","#",1

,"Cultura del Agua","http://www.sadm.gob.mx/cultura.html",0

)



m1mn5_1 = new Array

(

"Tratamiento de Aguas Residuales Area Metropolitana","http://www.sadm.gob.mx/tratamiento_metropolitana.html",0

)



m1mn5_2 = new Array

(

"Información geográfica","http://www.sadm.gob.mx/info_geografica.html",0

,"Drenaje pluvial","http://www.sadm.gob.mx/drenaje_pluvial.html",0

)



m1mn6 = new Array

(



"Transparencia","http://www.sadm.gob.mx/transparencia/transparencia.php",0

//,"Ley de Acceso a la Información Pública","http://www.sadm.gob.mx/LAIP.html",0

//,"Administración","#",1

//,"Pagos y Adquisiciones","#",1

//,"Organigrama","estructura.html",0

//,"Marco Legal","legal.php",0

//,"Presupuesto","ingresos_egresos.html",0

//,"Balance General","balance.html",0

//,"Nómina","nomina/nomina.php",0

//,"Información General","informacion_general.html",0

//,"Documentos y Cuentas Publicas SADM","documentos.html",0

//,"Adquisiciones","compras/detalle.php",0

//,"Catalogo de Proveedores","compras/proveedores.php",0

//,"Contratos de Adquisiciones de Bienes y Servicios","compras/adquisiciones.php",0

//,"Contratos de Obras","compras/obras.php",0

)


/*
m1mn6_1 = new Array

(

"Convocatorias","http://www.sadm.gob.mx/convocatorias.html",0

,"Fallos de Convocatorias","http://www.sadm.gob.mx/convocatorias_fallos.html",0

)

m1mn6_2 = new Array

(

"Cuenta Pública","http://www.sadm.gob.mx/cuentasPublicas.html",0

,"Informes Trimestrales","http://www.sadm.gob.mx/informesTrimestrales.html",0

)

m1mn6_3 = new Array

(

"Estado de Resultados","http://www.sadm.gob.mx/estado_resultados.html",0

,"Estado de situación Financiera","http://www.sadm.gob.mx/edo_sit_financiera.html",0

)

m1mn6_4 = new Array

(

"Materiales de Consumo","http://www.sadm.gob.mx/compras/materiales_consumo.php",0

,"Activos Fijos","http://www.sadm.gob.mx/compras/activos_fijos.php",0

,"Servicios","http://www.sadm.gob.mx/compras/servicios.php",0

,"Proveedores","http://www.sadm.gob.mx/compras/proveedores.php",0

,"Adquisiciones de Bienes y Servicios","http://www.sadm.gob.mx/compras/adquisiciones.php",0

,"Contratos de Obras","http://www.sadm.gob.mx/compras/obras.php",0

)
*/


absPath="";

if (m1.sepFrame && !m1.openSameFrame)

	{

	if (document.URL.lastIndexOf("\\")>document.URL.lastIndexOf("/")) {sepCh = "\\" ;} else {sepCh = "/" ;}

	absPath = document.URL.substring(0,document.URL.lastIndexOf(sepCh)+1);

	}

m1.popupOffset = 2;

m1.curPopupWidth=m1.popupWidth;

if (DOM||IE4||Opera7){

document.write("<img width=1 height=1 id='menubg4' src='menus/menubg4.gif' style='display:none' />");

document.write("<img width=1 height=1 id='menubg5' src='menus/menubg5.gif' style='display:none' />");

document.write("<img width=1 height=1 id='menubg6' src='menus/menubg6.gif' style='display:none' />");

}

if(Opera&&!Opera7) document.write("<"+"script language='JavaScript1.2' src='menus/menu_opera.js'><"+"/"+"script>");

else if (NS4) document.write("<"+"script language='JavaScript1.2' src='menus/menu_ns4.js'><"+"/"+"script>");

else if (document.getElementById) document.write("<"+"script language='JavaScript1.2' src='menus/menu_dom.js'><"+"/"+"script>");

else document.write("<"+"script language='JavaScript1.2' src='menus/menu_ie4.js'><"+"/"+"script>");

document.write("<style type='text/css'>\n");

document.write(".m1CL0 {text-decoration:none;color:Black; }\n");

if(!IE4&&!DOM) document.write(".topFold {position:relative}\n");

document.write(((NS4&&!m1.bBitmapScheme)?".m1mm2":".m1mit")+" {padding-left:1px;padding-right:1px;}\n");

document.write("</style>\n\n");

