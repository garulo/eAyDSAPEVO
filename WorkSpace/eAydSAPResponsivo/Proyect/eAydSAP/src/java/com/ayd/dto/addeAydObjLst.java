package com.ayd.dto;

import com.ayd.dao.RutaProperties;
import com.ayd.dao.ServicioNISDAO;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.Properties;
import jdk.nashorn.internal.ir.BreakNode;
import org.apache.tools.ant.taskdefs.email.Message;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class addeAydObjLst {

    int index = 0;
    int bound = eAydObjLst.lstDTO.size();
    eAydObjDTO eAydObj = new eAydObjDTO();
    Date d = new Date();
    long horacatual = d.getTime();
    boolean boool = false;
    long diferencia;

    public boolean eliminarAydObjLst() throws IOException, FileNotFoundException, JSONException {
        //System.out.println("eliminarAydObjLst");
        //System.out.println("horacatual " + horacatual);

        if (!eAydObjLst.lstDTO.isEmpty()) {

            System.out.println("Tamaño inicial de la lista AydObjList:: " + eAydObjLst.lstDTO.size());

            for (eAydObjDTO eAydObjDTO : eAydObjLst.lstDTO) {
                Long horaobjeto = eAydObjDTO.getDate().getTime();

                diferencia = (horacatual - horaobjeto);
                //System.out.println("diferencia: " + diferencia);
                //System.out.println("horaobjeto " + horaobjeto);
                //if(eAydObjLst.lstDTO.size()!=1){
                for (int userInd = 0; userInd < bound; userInd++) {
                    if (eAydObjLst.lstDTO.get(userInd).getUid().equals(eAydObjDTO.getUid())) {
                        index = userInd;
                        //System.out.println("transaccion id  existe :: " + index);

                    } else {
                        //System.out.println("transaccion id con el de la lista  no existe");
                    }
                    //(hr)00-(min)00-(seg)00-(miliseg)000 **59 min**
                    if (diferencia > 200000) {
                        //System.out.println(eAydObjDTO.getTransactionId()+" ::ValidaStatusAntes de eliminar: "+validarstatus(eAydObjDTO));
                        System.out.println("-->Removiendo Objeto de lista por exeder tiempo " + eAydObjDTO.getUid() + " generado en fecha: " + eAydObjDTO.getDate());
                        System.out.println(eAydObjDTO.getUid() + " -->Diferencia con la fecha actual: " + diferencia);
                        if (validarstatus(eAydObjDTO)) {
                            eAydObjLst.lstDTO.remove(index);
                            boool = true;
                        } else {
                            System.out.println("ValidaStatusAntes de eliminar: false / no se elimina de la lista: " + eAydObjDTO.getUid());
                            boool = false;
                        }
                    }

                }
                //}
            }
            System.out.println("AydObjList Tamaño final de la lista:: " + eAydObjLst.lstDTO.size());
        }

        return boool;
    }

    public static boolean validarstatus(eAydObjDTO eA) throws FileNotFoundException, IOException, JSONException {
        RutaProperties rp = new RutaProperties();
        String urlProperties = rp.getRuta();
        Properties oProperties = new Properties();
        InputStream isArchivo = new FileInputStream(urlProperties);
        oProperties.load(isArchivo);
        String tokenlogin = new String();
        boolean ret = false;
        String email = eA.getEmail();
        String StatTransacId = eA.getTransactionId();
        Date fechaactual = new Date();
        try {
            System.out.println("::::: Consultar Estatus de transacción antes de borrar AydObjList:::::" + eA.getTransactionId());
            String QBITSPAYMENTSSTATUS = oProperties.getProperty("QBITSPAYMENTSSTATUS");
            URL urlStatus = new URL(QBITSPAYMENTSSTATUS + eA.getTransactionId() + "");
            System.out.println("url:: " + urlStatus);
            HttpURLConnection connStatus = (HttpURLConnection) urlStatus.openConnection();
            connStatus.setRequestMethod("GET");
            connStatus.setRequestProperty("Accept", "application/json");
            System.out.println("AydObjList connStatus :: " + connStatus);
            System.out.println("AydObjList connStatus code :: " + connStatus.getResponseCode());
            if (connStatus.getResponseCode() != 200) {
                System.out.println("AydObjList error QBITSPAYMENTSSTATUS connStatus code :: " + connStatus.getResponseCode());
                System.out.println("AydObjList QBITSPAYMENTSSTATUS no exitoso: response msj " + connStatus.getResponseMessage());
                ret = false;
            } else {
                System.out.println("::::");

                try {
                    InputStream inputStreamStatus = connStatus.getInputStream();
                    String jsonstatus = new String();
                    BufferedReader bufferedReaderstatus = new BufferedReader(new InputStreamReader(inputStreamStatus), 1);
                    String linestatus;
                    while ((linestatus = bufferedReaderstatus.readLine()) != null) {
                        jsonstatus = linestatus;
                    }
                    bufferedReaderstatus.close();
                    bufferedReaderstatus.close();
                    JSONObject jsonObjstatus = new JSONObject(jsonstatus);
                    System.out.println("Response status transaction json AydObjList:: " + jsonstatus.toString());
                    String StatusProsaCode = jsonObjstatus.get("prosaCode").toString();
                    System.out.println("StatusProsaCode AydObjList::" + StatusProsaCode);
                    String StatusMessage = jsonObjstatus.get("message").toString();
                    JSONObject jsonObjmessageObj = new JSONObject(jsonObjstatus.get("messageObject").toString());
                    System.out.println("jsonObjmessageObj :: " +jsonObjmessageObj.toString());
                    String StatusTraceNumber = jsonObjmessageObj.get("traceNumber").toString();
           //System.out.println("StatusTraceNumber :: " + StatusTraceNumber);
                    String StatusAuthorizationCode = jsonObjmessageObj.get("authorizationCode").toString();
            //System.out.println("StatusAuthorizationCode :: " + StatusAuthorizationCode);
                    String StatusAmount = jsonObjmessageObj.get("amount").toString();
                    //        String StatusAmount = "000000000000";
                    if (StatusProsaCode.equalsIgnoreCase("00")) {

                        System.out.println("AydObjList:::Recuperar token sesion:::");

                        String LOGINZ = oProperties.getProperty("LOGIN");
                        URL urlz = new URL(LOGINZ + eA.getEmail() + "&Password=" + eA.getPassword() + "&IdSistema=eAyd");
                        HttpURLConnection conn = (HttpURLConnection) urlz.openConnection();
                        conn.setRequestMethod("GET");
                        conn.setRequestProperty("Accept", "application/json");
                        if (conn.getResponseCode() != 200) {
                            System.out.println("AydObjList Login no exitoso: response code " + conn.getResponseCode());
                            ret = false;
                            //throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());

                        } else {
                            try {
                                System.out.println("AydObjList Login  exitoso: response code " + conn.getResponseCode() + " / " + eA.getEmail() + " / " + eA.getTransactionId());

                                InputStream inputStream = conn.getInputStream();
                                String json = new String();
                                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream), 1);
                                String line;
                                while ((line = bufferedReader.readLine()) != null) {
                                    json = line;
                                }
                                inputStream.close();
                                bufferedReader.close();
                                //System.out.println("json ::: " + json);
                                JSONObject jsonObj = new JSONObject(json);
                                //System.out.println("::jsonObj.get(\"Response\").toString():: "+jsonObj.get("Response").toString());
                                if ("null" != jsonObj.get("Response").toString()) {
                                    JSONObject jsonObjloginresponse = new JSONObject(jsonObj.get("Response").toString());
                                    JSONObject jsonObjloginresponsedata = new JSONObject(jsonObjloginresponse.get("data").toString());
                                    System.out.println("LOGIN jsonObjloginresponsedata AydObjList:: " + jsonObjloginresponsedata);
                                    JSONObject jsonObjloginresponsedatauser = new JSONObject(jsonObjloginresponsedata.get("Usuario").toString());
                                    tokenlogin = jsonObjloginresponsedata.get("Token").toString();
                                    System.out.println("token AydObjList:: " + tokenlogin);
                                }
                            } catch (IOException ioe) {
                                ioe.printStackTrace();
                            } catch (JSONException ex) {
                                ex.printStackTrace();
                            }
                        }

                        System.out.println(":::Recalcular nis AydObjList:::");
                        String IdSistema = "eAyd";
                        String montopagar = eA.getMontopagar();
                        String nispagardt = eA.getNispagardt();
                        String transactionId = eA.getTransactionId();
                        String vpc_MerchTxnRef = eA.getVpc_MerchTxnRef();

                        //Recalcular y enlistar nis para su iteración en validaciones y envio de notificaciones 
                        String[] listNisPagar = nispagardt.split("nis");
                        ArrayList<ServicioNISDAO> lstServ = new ArrayList();
                        String SELSALDOS = oProperties.getProperty("SELSALDOS");
                        URL urlsaldos = new URL(SELSALDOS + eA.getEmail());

                        HttpURLConnection connsaldos = (HttpURLConnection) urlsaldos.openConnection();
                        connsaldos.setRequestMethod("GET");
                        connsaldos.setRequestProperty("Accept", "application/json");
                        connsaldos.setRequestProperty("Authorization", "Bearer " + tokenlogin);

                        if (connsaldos.getResponseCode() != 200) {

                            System.out.println("Failed SELSALDOS : HTTP error code  limpiar lista sel saldos: " + conn.getResponseCode());
                            System.out.println("SELSALDOS no exitoso: response code " + conn.getResponseCode() + "/" + eA.getTransactionId());
                            ret = false;
//throw new RuntimeException("Failed : HTTP error code : " + connsaldos.getResponseCode());

                        } else {
                            System.out.println("RecalcularSaldos SELSALDOS AydObjList:: " + eA.getTransactionId());
                            try {

                                InputStream inputStreamsaldos = connsaldos.getInputStream();
                                String jsonsaldos = new String();
                                BufferedReader bufferedReadersaldos = new BufferedReader(new InputStreamReader(inputStreamsaldos), 1);
                                String linesaldos = "";
                                while ((linesaldos = bufferedReadersaldos.readLine()) != null) {
                                    jsonsaldos = linesaldos;
                                }
                                inputStreamsaldos.close();
                                bufferedReadersaldos.close();
                                //System.out.println("json ::: " + json);
                                JSONObject jsonObjsaldos = new JSONObject(jsonsaldos);

                                JSONObject jsonObjservresponse = new JSONObject(jsonObjsaldos.get("Response").toString());
                                // System.out.println("strjsonObjservresponsedata :: " +jsonObjservresponse.toString());
                                String strjsonObjservresponsedata = jsonObjservresponse.get("data").toString();

                                strjsonObjservresponsedata = strjsonObjservresponsedata.replace("[", "");
                                strjsonObjservresponsedata = strjsonObjservresponsedata.replace("]", "");

                                //System.out.println("strjsonObjservresponsedata :: " + strjsonObjservresponsedata);
                                JSONObject jsonObjservresponsedata = new JSONObject(strjsonObjservresponsedata);
                                System.out.println("jsonObjservresponsedata SELSALDOS AydObjList:: " + jsonObjservresponsedata.toString());

                                JSONArray results = new JSONArray(jsonObjservresponse.get("data").toString());

                                System.out.println("result:: " + results.length());
                                for (int i = 0; i < results.length(); i++) {
                                    JSONObject aux = results.getJSONObject(i);
                                    ServicioNISDAO serv = new ServicioNISDAO();
                                    serv.setV_nis_rad(aux.get("NIS").toString());
                                    serv.setV_sec_rec("0");
                                    serv.setV_f_fact(aux.get("Fecha_Venc").toString());
                                    serv.setV_sec_nis(aux.get("Fecha_Venc").toString());
                                    serv.setV_f_vcto(aux.get("Fecha_Venc").toString());
                                    serv.setV_importe(Double.parseDouble(aux.get("v_totaladeu").toString()));
                                    String strDomicilio = "" + aux.get("Direccion").toString() + " ";
                                    String strdomicilioLegible = new String(strDomicilio.getBytes("ISO-8859-1"), "UTF-8");
                                    serv.setP_Direccion(strdomicilioLegible);
                                    serv.setPartner(aux.get("Partner").toString());
                                    serv.setVkont(aux.get("Vkont").toString());
                                    lstServ.add(serv);
                                }
                                connsaldos.disconnect();
                            } catch (IOException ioe) {
                                System.out.println("excepcion IOException SELSALDOS AydObjList:: " + ioe);
                                ret = false;
                            } catch (JSONException ex) {
                                System.out.println("excepcion JSONException SELSALDOS AydObjList:: " + ex);
                                ret = false;
                            }
                        }
                        double amountcalc = 0;

                        for (String n : listNisPagar) {
                            for (ServicioNISDAO sn : lstServ) {
                                if (n.substring(0, 9).equalsIgnoreCase(sn.getV_nis_rad())) {

                                    amountcalc = amountcalc + sn.getV_importe();

                                }
                            }
                        }
                        String abc = String.valueOf(amountcalc);
                        abc = abc.replace(".", "");
                        amountcalc = Double.parseDouble(abc) * 100;

                        Long lon = Long.parseLong(abc) * 10;
                        System.out.println("::::::::: amountcalc: " + lon);
                        String finalamountcalc = "" + lon;
                        for (int i = finalamountcalc.length(); i < 12; i++) {
                            finalamountcalc = "0" + finalamountcalc;
                        }

                        System.out.println(amountcalc + " ::El amountcalc recalculado y formateado para bitspay AydObjList a 12 digitos" + finalamountcalc);

                        System.out.println(vpc_MerchTxnRef + "AydObjList :: Montos : StatusAmount= " + StatusAmount + " / finalamountcalc= " + finalamountcalc);

                        if (StatusAmount.equalsIgnoreCase(finalamountcalc.toString())) {

                            System.out.println("AydObjList Montos validados ref: " + vpc_MerchTxnRef);
                            System.out.println("AydObjList Actualización y notificaciones de pago a servicios");

                            //Iteración de notificacion PAYMENTSAP/insertpagosql
                            for (String n : listNisPagar) {
                                System.out.println("AydObjList n.substring(0, 9) :" + n.substring(0, 9));
                                for (ServicioNISDAO sn : lstServ) {
                                    System.out.println("AydObjList sn.getV_nis_rad() :" + sn.getV_nis_rad());

                                    if (n.substring(0, 9).equalsIgnoreCase(sn.getV_nis_rad())) {

                                        if (sn.getV_importe() > 0) {
                                            

                                            String INSERTARSERVICIOPAGOSQL = oProperties.getProperty("INSERTARSERVICIOPAGOSQL");
                                            System.out.println("AydObjList:: INSERTARSERVICIOPAGOSQL : " + INSERTARSERVICIOPAGOSQL + "::: " + sn.getV_nis_rad());

                                            URL urlinsertarServicioPagoSQL = new URL(INSERTARSERVICIOPAGOSQL);
                                            HttpURLConnection coninsertarServicioPagoSQL = (HttpURLConnection) urlinsertarServicioPagoSQL.openConnection();
                                            coninsertarServicioPagoSQL.setRequestMethod("POST");
                                            coninsertarServicioPagoSQL.setRequestProperty("Content-Type", "application/json; utf-8");
                                            coninsertarServicioPagoSQL.setDoOutput(true);
                                            coninsertarServicioPagoSQL.setRequestProperty("Authorization", "Bearer " + tokenlogin);

                                            String jsonIString = "{\n"
                                                    + "  \"v_nis_rad\": \"" + sn.getV_nis_rad() + "\",\n"
                                                    + "  \"v_sec_rec\": \"" + sn.getV_sec_rec() + "\",\n"
                                                    + "  \"v_f_fact\": \"" + sn.getV_f_fact() + "\",\n"
                                                    + "  \"v_sec_nis\": \"" + sn.getV_sec_nis() + "\",\n"
                                                    + "  \"v_f_vcto\": \"" + sn.getV_f_vcto() + "\",\n"
                                                    + "  \"v_importe\": \"" + sn.getV_importe() + "\",\n"
                                                    + "  \"v_referencia\": \"" + vpc_MerchTxnRef + "\",\n"
                                                    + "  \"email\": \"" + email + "\",\n"
                                                    + "  \"P_Direccion\": \"" + sn.getP_Direccion() + "\",\n"
                                                    + "  \"authorizationId\": \"" + StatusAuthorizationCode + "\"\n"
                                                    + "}";
                                            System.out.println("AydObjList jsonInputStringinsertarServicioPagoSQL ::: " + jsonIString);
                                            try (OutputStream os = coninsertarServicioPagoSQL.getOutputStream()) {
                                                byte[] input = jsonIString.getBytes("utf-8");
                                                os.write(input, 0, input.length);
                                            }

                                            try (BufferedReader bdata = new BufferedReader(
                                                    new InputStreamReader(coninsertarServicioPagoSQL.getInputStream(), "utf-8"))) {
                                                String jsondata = new String();
                                                InputStream inputStreamdata = coninsertarServicioPagoSQL.getInputStream();
                                                BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
                                                String lineuserdata;
                                                while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                                                    jsondata = lineuserdata;
                                                }
                                                System.out.println("AydObjList jsondata coninsertarServicioPagoSQL ::: " + jsondata);
                                                inputStreamdata.close();
                                                bufferedReaderdata.close();
                                                JSONObject jsonObjdata = new JSONObject(jsondata);

                                                if (jsonObjdata.get("success").toString() == "true") {
                                                    String msg = jsonObjdata.get("message").toString();
                                                    msg = msg.replace("Ã±", "ñ");
                                                    System.out.println("AydObjList success service coninsertarServicioPagoSQL TRUE:::::");
                                                    ret = true;

                                                } else {
                                                    System.out.println("AydObjList success service coninsertarServicioPagoSQL FALSE:::::");
                                                    ret = false;

                                                }
                                            } catch (JSONException ex) {
                                                System.out.println("AydObjList JSON EXCEPTION coninsertarServicioPagoSQL: " + ex);
                                                ret = false;
                                            }

                                            System.out.println("try PAYMENTSAP NIS: " + sn.getV_nis_rad() + "/" + fechaactual + " / " + StatTransacId + " amount: " + sn.getV_importe());

                                            String PAYMENTSAP = oProperties.getProperty("PAYMENTSAP");

                                            URL urlinsertarServicioPago = new URL(PAYMENTSAP);
                                            System.out.println("urlPaymentSap: " + PAYMENTSAP + "::: " + sn.getV_nis_rad() + "/" + fechaactual + " / " + StatTransacId);
                                            HttpURLConnection coninsertarServicioPago = (HttpURLConnection) urlinsertarServicioPago.openConnection();
                                            coninsertarServicioPago.setRequestMethod("POST");
                                            coninsertarServicioPago.setRequestProperty("Content-Type", "application/json; utf-8");
                                            coninsertarServicioPago.setDoOutput(true);
                                            coninsertarServicioPago.setRequestProperty("Authorization", "Bearer " + tokenlogin);

                                            //TODO
                                            Date dat = new Date();
                                            //System.out.println("dtIDMessageHeader:: "+new SimpleDateFormat("ddMMyyyy").format(dat));
                                            String dtIDMessageHeader = new SimpleDateFormat("ddMMyyyy").format(dat);
                                            String DtCreationMessageHeader = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dat);
                                            //System.out.println("DtCreationMessageHeader :: "+DtCreationMessageHeader);
                                            String valueDt = new SimpleDateFormat("yyyy-MM-dd").format(dat);
                                            int consecutivo = (int) (99999 * Math.random());
                                            String fconsecutivo = "" + consecutivo;
                                            for (int i = fconsecutivo.length(); i < 5; i++) {
                                                fconsecutivo = "0" + fconsecutivo;
                                            }
                                            int consecutivo1 = (int) (999 * Math.random());
                                            String fconsecutivo1 = "" + consecutivo1;
                                            for (int i = fconsecutivo1.length(); i < 3; i++) {
                                                fconsecutivo1 = "0" + fconsecutivo1;
                                            }

                                            String IDMessageHeader = "PAY-" + dtIDMessageHeader + "-" + fconsecutivo;//(Pay + fecha (ddMMyyyy) + consecutivo(00001))";
                                            String DateCreationMessageHeader = DtCreationMessageHeader;//(formato: yyyy-MM-dd’T’HH:mm:ss’Z’).
                                            String CashPointReferenceID = "E99";//(Caja)//Qbits code web eAyd??????
                                            String CashPointOfficeReferenceID = "SADM_1INT";//(Oficina)TODO
                                            String CashPointPaymentGroupReferenceID = "EAF-" + dtIDMessageHeader + "-001" ;//(Grupos del Pagos del Dia APP-ddMMyyyy- consecutivo).
                                            String PaymentTransactionID = IDMessageHeader;//(Igual que el parámetro “ID”).
                                            String PaymentAmount = String.valueOf(sn.getV_importe());//(Añadir atributo currencyCode = MxN).
                                            String ValueDate = valueDt;//(Formato Fecha yyyy-MM-dd).
                                            String OnAccountIndicator = "false";
                                            String OutgoingPayment = "false";
                                            String InternalID = sn.getPartner();//(PARTNER. Obtenido de WSDL Consulta).
                                            String DebtorInternalID = InternalID;//. (Igual que el parametro “InternalID”).
                                            System.out.println("sn.getVkont(): " + sn.getVkont());
                                            String ContractAccountReferenceID = sn.getVkont();//. (VKONT. Obtenido de WSDL Consulta).
                                            String ContractReferenceID = sn.getV_nis_rad();//(NIS).

                                            String jsonInString = "{\n"
                                                    + "  \"IDMessageHeader\": \"" + IDMessageHeader + "\",\n"
                                                    + "  \"DateCreationMessageHeader\": \"" + DateCreationMessageHeader + "\",\n"
                                                    + "  \"CashPointReferenceID\": \"" + CashPointReferenceID + "\",\n"
                                                    + "  \"CashPointOfficeReferenceID\": \"" + CashPointOfficeReferenceID + "\",\n"
                                                    + "  \"CashPointPaymentGroupReferenceID\": \"" + CashPointPaymentGroupReferenceID + "\",\n"
                                                    + "  \"PaymentTransactionID\": \"" + PaymentTransactionID + "\",\n"
                                                    + "  \"PaymentAmount\": \"" + PaymentAmount + "\",\n"
                                                    + "  \"ValueDate\": \"" + ValueDate + "\",\n"
                                                    + "  \"OnAccountIndicator\": \"" + OnAccountIndicator + "\",\n"
                                                    + "  \"OutgoingPayment\": \"" + OutgoingPayment + "\",\n"
                                                    + "  \"InternalID\": \"" + InternalID + "\",\n"
                                                    + "  \"DebtorInternalID\": \"" + DebtorInternalID + "\",\n"
                                                    + "  \"ContractAccountReferenceID\": \"" + ContractAccountReferenceID + "\",\n"
                                                    + "  \"ContractReferenceID\": \"" + ContractReferenceID + "\"\n"
                                                    + "}";
                                            System.out.println("AydObjList jsonInputStringPAYMENTSAP ::: " + jsonInString);
                                            try (OutputStream os = coninsertarServicioPago.getOutputStream()) {
                                                byte[] input = jsonInString.getBytes("utf-8");
                                                os.write(input, 0, input.length);
                                            }

                                            try (BufferedReader bdata = new BufferedReader(
                                                    new InputStreamReader(coninsertarServicioPago.getInputStream(), "utf-8"))) {
                                                String jsondata = new String();
                                                InputStream inputStreamdata = coninsertarServicioPago.getInputStream();
                                                BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
                                                String lineuserdata;
                                                while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                                                    jsondata = lineuserdata;
                                                }
                                                System.out.println("AydObjList jsondata con consumir PAYMENTSAP ::: " + sn.getV_nis_rad() + "/" + fechaactual + " / " + StatTransacId + jsondata);
                                                inputStreamdata.close();
                                                bufferedReaderdata.close();
                                                JSONObject jsonObjdata = new JSONObject(jsondata);

                                                if (jsonObjdata.get("success").toString() == "true") {
                                                    String msg = jsonObjdata.get("message").toString();
                                                    msg = msg.replace("Ã±", "ñ");
                                                    System.out.println("AydObjList success service PAYMENTSAP TRUE:::::" + sn.getV_nis_rad() + "/" + fechaactual + " / " + StatTransacId);

                                                } else {
                                                    System.out.println("AydObjList success service PAYMENTSAP FALSE:::::" + sn.getV_nis_rad() + "/" + fechaactual + " / " + StatTransacId);
                                                    ret = false;

                                                }
                                            } catch (JSONException ex) {
                                                System.out.println(StatTransacId + "AydObjList PAYMENTSAP JSON EXCEPTION response code: " + fechaactual + " / " + ex);
                                                ret = false;
                                            }
                                            
                                        } else {
                                            System.out.println("AydObjList el importe del nis no puede notificarse en con monto 0");
                                            ret = false;
                                        }

                                    } else {
                                        System.out.println(":: AydObjList ");
                                        System.out.println("el contrato  no es el mismo para notificar pago");
                                    }
                                }
                            }
                            //Notificacion UpdateReferencia
                            String UPDATEREFERENCIA = oProperties.getProperty("UPDATEREFERENCIA");
                            System.out.println("" + UPDATEREFERENCIA + " ::: " + transactionId);
                            URL urlUpdateReferencia = new URL(UPDATEREFERENCIA);
                            HttpURLConnection conUpdateReferencia = (HttpURLConnection) urlUpdateReferencia.openConnection();
                            conUpdateReferencia.setRequestMethod("POST");
                            conUpdateReferencia.setRequestProperty("Content-Type", "application/json; utf-8");
                            conUpdateReferencia.setDoOutput(true);
                            conUpdateReferencia.setRequestProperty("Authorization", "Bearer " + tokenlogin);

                            String jsonIStr = "{\n"
                                    + "  \"Mensaje\": \"" + StatusProsaCode + "\" ,\n"
                                    + "  \"Referencia\": \"EAF" + transactionId + "\",\n"
                                    + "  \"Campo\": \""+StatusAuthorizationCode+"\"\n"
                                    + "}";
                            System.out.println("jsonInputStringUpdateReferencia ::: " + jsonIStr);
                            try (OutputStream os = conUpdateReferencia.getOutputStream()) {
                                byte[] input = jsonIStr.getBytes("utf-8");
                                os.write(input, 0, input.length);
                            }

                            try (BufferedReader bdata = new BufferedReader(
                                    new InputStreamReader(conUpdateReferencia.getInputStream(), "utf-8"))) {
                                String jsondata = new String();
                                InputStream inputStreamdata = conUpdateReferencia.getInputStream();
                                BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
                                String lineuserdata;
                                while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                                    jsondata = lineuserdata;
                                }
                                System.out.println("jsondata conUpdateReferencia ::: " + jsondata);
                                inputStreamdata.close();
                                bufferedReaderdata.close();
                                JSONObject jsonObjdata = new JSONObject(jsondata);

                                if (jsonObjdata.get("success").toString() == "true") {
                                    String msg = jsonObjdata.get("message").toString();
                                    msg = msg.replace("Ã±", "ñ");

                                    System.out.println("success service conUpdateReferencia TRUE:::::eliminar de la lista ::");
                                    return true;
                                }
                                System.out.println("success service conUpdateReferencia FALSE:::::");

                            }
                        } else {
                            System.out.println("AydObjList Montos no coinciden en ref: " + vpc_MerchTxnRef + " Se elimina de lista");
                            return true;
                        }

                    }else{
                        System.out.println("El codigo no es 00");
                    
                          //Notificacion UpdateReferencia
                            String UPDATEREFERENCIA = oProperties.getProperty("UPDATEREFERENCIA");
                            System.out.println("" + UPDATEREFERENCIA + " ::: " + eA.getTransactionId());
                            URL urlUpdateReferencia = new URL(UPDATEREFERENCIA);
                            HttpURLConnection conUpdateReferencia = (HttpURLConnection) urlUpdateReferencia.openConnection();
                            conUpdateReferencia.setRequestMethod("POST");
                            conUpdateReferencia.setRequestProperty("Content-Type", "application/json; utf-8");
                            conUpdateReferencia.setDoOutput(true);
                            conUpdateReferencia.setRequestProperty("Authorization", "Bearer " + tokenlogin);

                            String jsonIStr = "{\n"
                                    + "  \"Mensaje\": \"" + StatusProsaCode + "\" ,\n"
                                    + "  \"Referencia\": \"EAF" + eA.getTransactionId() + "\",\n"
                                    + "  \"Campo\": \"-\"\n"
                                    + "}";
                            System.out.println("jsonInputStringUpdateReferencia ::: " + jsonIStr);
                            try (OutputStream os = conUpdateReferencia.getOutputStream()) {
                                byte[] input = jsonIStr.getBytes("utf-8");
                                os.write(input, 0, input.length);
                            }

                            try (BufferedReader bdata = new BufferedReader(
                                    new InputStreamReader(conUpdateReferencia.getInputStream(), "utf-8"))) {
                                String jsondata = new String();
                                InputStream inputStreamdata = conUpdateReferencia.getInputStream();
                                BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
                                String lineuserdata;
                                while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                                    jsondata = lineuserdata;
                                }
                                System.out.println("jsondata conUpdateReferencia ::: " + jsondata);
                                inputStreamdata.close();
                                bufferedReaderdata.close();
                                JSONObject jsonObjdata = new JSONObject(jsondata);

                                if (jsonObjdata.get("success").toString() == "true") {
                                    String msg = jsonObjdata.get("message").toString();
                                    msg = msg.replace("Ã±", "ñ");

                                    System.out.println("success service conUpdateReferencia TRUE:::::eliminar de la lista ::");
                                   ret=true;
                                }
                                System.out.println("success service conUpdateReferencia FALSE:::::");

                            }
                        
                        
                        
                        ret=true;
                    
                    }
                    
                    

                } catch (Exception e) {
                    System.out.println("AydObjListException : " + e);
                    ret = true;
                }
            }
        } catch (Exception e) {
            System.out.println("AydObjListException fin : " + e);
            ret = false;
        }
        return ret;
    }

//    public static void main(String[] args) throws IOException {
//        eAydObjDTO e = new eAydObjDTO();
//        e.setTransactionId("6b71d1ea-6d11-4309-83b8-389e5edc49ec5255");
//        e.setDate(new Date());
//        e.setEmail("garulo.trabajo@gmail.com");
//        e.setPassword("BAFB72E49607A15E663F13C2A4B3E3184E05515022085533300323A95F314DF1");
//        e.setIdSistema("eAydPrueba");
//        e.setMontopagar("0");
//        e.setNispagardt("5143114");
//        e.setVpc_MerchTxnRef("EAF6b71d1ea-6d11-4309-83b8-389e5edc49ec5255");
//        validarstatus(e);
//    }
}
