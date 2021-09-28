

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <script src="https://evopaymentsmexico.gateway.mastercard.com/checkout/version/61/checkout.js" data-error="errorCallback" data-cancel="cancelCallback"></script>
        <script type="text/javascript">
            function errorCallback(error) {
                  console.log(JSON.stringify(error));
            }
            function cancelCallback() {
                  console.log('Payment cancelled');
            }
            Checkout.configure({
              session: { 
            	id: 'SESSION0002891066201M24041279M6'
       			},
             interaction: {
                    merchant: {
                        name: 'TESTAGUADRENMTY',
                        address: {
                            line1: '200 Sample St',
                            line2: '1234 Example Town'            
                        }    
                    }
               }
            });
        </script>
		 <link href="imagenes/logo_transp.gif" rel="shortcut icon" type="image/x-icon" />
        <link href="imagenes/logo_transp.gif" rel="apple-touch-icon" />
        <meta name="tipo_contenido"  content="text/html;" http-equiv="content-type" charset="utf-8">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <meta http-equiv="Content-Type" content="text/html charset=utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <%@ include file="HeaderOptions.jsp" %>
        <title>CheckOut</title>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" src="js/script.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

    </head>
    <body>
          
        <div style="margin-top: 20%;">
	
        
		<center><img src='imagenes/logo_transp.gif'></br>
       ...
       <input class="btn btn-outline-secondary" type="button" value="Pagar" onclick="Checkout.showLightbox();" />
      <input class="btn btn-outline-secondary" type="button" value="Pay with Payment Page" onclick="Checkout.showPaymentPage();" />
       ...
        </div>
        <%@include file="Bottom.jsp" %>
    </body>
</html>
