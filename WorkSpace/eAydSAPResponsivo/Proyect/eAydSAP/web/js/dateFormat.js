/**
* script para validar fechas en una caja de texto.
*@Autor  Angel Cantú Herrera
*/
    
    /**
    * definimos las variables globales que van a contener la fecha completa, cada una de sus partes
    * y los dias correspondientes al mes de febrero segun sea el año bisiesto o no
    */
    var a, mes, dia, anyo, febrero;
    
    /**
    * funcion para comprobar si una año es bisiesto
    * argumento anyo > año extraido de la fecha introducida por el usuario
    */
    function anyoBisiesto(anyo)
    {
        /**
        * si el año introducido es de dos cifras lo pasamos al periodo de 1900. Ejemplo: 25 > 1925
        */
        if (anyo < 100)
            var fin = anyo + 1900;
        else
            var fin = anyo ;

        /*
        * primera condicion: si el resto de dividir el año entre 4 no es cero > el año no es bisiesto
        * es decir, obtenemos año modulo 4, teniendo que cumplirse anyo mod(4)=0 para bisiesto
        */
        if (fin % 4 != 0)
            return false;
        else
        {
            if (fin % 100 == 0)
            {
                /**
                * si el año es divisible por 4 y por 100 y divisible por 400 > es bisiesto
                */
                if (fin % 400 == 0)
                {
                    return true;
                }
                /**
                * si es divisible por 4 y por 100 pero no lo es por 400 > no es bisiesto
                */
                else
                {
                    return false;
                }
            }
            /**
            * si es divisible por 4 y no es divisible por 100 > el año es bisiesto
            */
            else
            {
                return true;
            }
        }
    }
    
    /**
    * funcion principal de validacion de la fecha
    * argumento fecha > cadena de texto de la fecha introducida por el usuario
    */
    function validarFecha(form)
    {
    		//var campo = form;
       /**
       * obtenemos la fecha introducida y la separamos en dia, mes y año
       */
       if (form.value == ""){
		   	return;
	   }
	   a=form.value;
       dia=a.split("/")[0];
       mes=a.split("/")[1];
       anyo=a.split("/")[2];
	   
	   if (mes){
		   //el mes es correcto
	   } else {
	   	   alert("La fecha es invalida.\nFavor de verificar el formato que se indica.");
		   form.focus();
                   form.select();
           return;
	   }
	   if (anyo){
		   //el año es correcto
	   } else {
	   	   alert("La fecha es invalida.\nFavor de verificar el formato que se indica.");
		   form.focus();
                   form.select();
                   return;
	   }
       
       if(anyoBisiesto(anyo))
           febrero=29;
       else
           febrero=28;
       /**
       * si el mes introducido es negativo, 0 o mayor que 12 > alertamos y detenemos ejecucion
       */
       if ((mes<1) || (mes>12))
       {
           alert("El mes introducido no es valido. Por favor, introduzca un mes correcto");
           form.value="";
           form.focus();
           form.select();
           return;
       }
       /**
       * si el mes introducido es febrero y el dia es mayor que el correspondiente 
       * al año introducido > alertamos y detenemos ejecucion
       */
       if ((mes==2) && ((dia<1) || (dia>febrero)))
       {
           alert("El dia introducido no es valido. Por favor, introduzca un dia correcto");
           form.focus();
           form.select();
           return;
       }
       /**
       * si el mes introducido es de 31 dias y el dia introducido es mayor de 31 > alertamos y detenemos ejecucion
       */
       if (((mes==1) || (mes==3) || (mes==5) || (mes==7) || (mes==8) || (mes==10) || (mes==12)) && ((dia<1) || (dia>31)))
       {
           alert("El dia introducido no es valido. Por favor, introduzca un dia correcto");
           form.focus();
           form.select();
           return;
       }
       /**
       * si el mes introducido es de 30 dias y el dia introducido es mayor de 301 > alertamos y detenemos ejecucion
       */
       if (((mes==4) || (mes==6) || (mes==9) || (mes==11)) && ((dia<1) || (dia>30)))
       {
           alert("El dia introducido no es valido. Por favor, introduzca un dia correcto");
           form.focus();
           form.select();
           return;
       }
       /**
       * si el mes año introducido es menor que 1900 o mayor que 2010 > alertamos y detenemos ejecucion
       * NOTA: estos valores son a eleccion vuestra, y no constituyen por si solos fecha erronea
       */
       if ((anyo<1900) || (anyo>2099))
       {
           alert("El año introducido no es valido. Por favor, introduzca un año entre 1900 y 2099");
           form.focus();
           form.select();
       } 
       /**
       * en caso de que todo sea correcto > enviamos los datos del formulario
       * para ello debeis descomentar la ultima sentencia
       */
       //else
       //   alert("La fecha introducida es correcta. Gracias por su colaboración");
          //document.frmNoticia.submit();    
    }


function changeOption(commandName, actionName) {
	document.objectInfo.command.value = commandName;
	document.objectInfo.action = actionName;
	document.objectInfo.submit();
}