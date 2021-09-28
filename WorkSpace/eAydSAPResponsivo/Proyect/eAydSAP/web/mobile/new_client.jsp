<%@ page language="java" import="com.ayd.domain.OnLinePaymentUser, com.ayd.domain.NISService, com.ayd.domain.Payment, java.util.Vector" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <meta name="viewport" content="width=device-width, initial-scale=1"> 
        <title>Mobile AyD Mty.</title>
        <link rel="stylesheet" href="mobile/jquery.mobile-1.0a2.min.css" />
        <script src="mobile/jquery-1.4.4.min.js"></script>
        <script src="mobile/jquery.mobile-1.0a2.min.js"></script>
        <style>
        .ui-grid-b img {
            width  : 100%;
            height : auto;
        }
        #Top {
            background-color: #F8F8F8;
        }
        .full {
            width: 100%;
        }


        </style>

    </head>
    <body>
        <div data-role="page" id="page"data-theme="c">

            <div data-role="header" data-position="fixed" id="Top">
                <img src="mobile/images/banner.jpg" class="full" />
            </div><!-- /header -->

            <div data-role="content">
                <form action="mC" method="post">
                    <input type="hidden" name="nisRad" value="" />
                    <input type="hidden" name="command" value="mRegistraNew" />
                    <fieldset>
                        <div data-role="fieldcontain">
                            <label for="email">Email:</label>
                            <input type="text" name="email" id="input" value="" size="15" data-theme="c"><br>
                            <label for="pass">Password:</label>
                            <input type="password" name="pass" id="input" value="" size="15" data-theme="c">
                        </div>
                        <button type="submit" data-theme="b">Registrar</button>
                    </fieldset>
                </form>

            </div><!-- /content -->

            <div data-role="footer">
                <img src="mobile/images/registra_mail.jpg" class="full" />
            </div><!-- /footer -->
        </div><!-- /page -->
    </body>
</html>
