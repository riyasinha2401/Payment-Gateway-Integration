<%@ page import="java.util.*" %>
<%@ page import="java.security.*" %>

<%!
public boolean empty(String s)
	{
		if(s== null || s.trim().equals(""))
			return true;
		else
			return false;
	}
%>
<%!
	public String hashCal(String type,String str){
		byte[] hashseq=str.getBytes();
		StringBuffer hexString = new StringBuffer();
		try{
		MessageDigest algorithm = MessageDigest.getInstance(type);
		algorithm.reset();
		algorithm.update(hashseq);
		byte messageDigest[] = algorithm.digest();
            
		

		for (int i=0;i<messageDigest.length;i++) {
			String hex=Integer.toHexString(0xFF & messageDigest[i]);
			if(hex.length()==1) hexString.append("0");
			hexString.append(hex);
		}
			
		}catch(NoSuchAlgorithmException nsae){ }
		
		return hexString.toString();


	}
%>
<% 	
	String merchant_key="mBSKnIdI";
	String salt="CxUo6kDZ6X";
	String action1 ="";
	String base_url="https://sandboxsecure.payu.in";
	int error=0;
	String hashString="";
	
 

	
	Enumeration paramNames = request.getParameterNames();
	Map<String,String> params= new HashMap<String,String>();
    	while(paramNames.hasMoreElements()) 
	{
      		String paramName = (String)paramNames.nextElement();
      
      		String paramValue = request.getParameter(paramName);

		params.put(paramName,paramValue);
	}
	String txnid ="";
	if(empty(params.get("txnid"))){
		Random rand = new Random();
		String rndm = Integer.toString(rand.nextInt())+(System.currentTimeMillis() / 1000L);
		txnid=hashCal("SHA-256",rndm).substring(0,20);
	}
	else
		txnid=params.get("txnid");
                    String udf2 = txnid;
	String txn="abcd";
	String hash="";
	String hashSequence = "key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10";
	if(empty(params.get("hash")) && params.size()>0)
	{
		if( empty(params.get("key"))
			|| empty(params.get("txnid"))
			|| empty(params.get("amount"))
			|| empty(params.get("firstname"))
			|| empty(params.get("email"))
			|| empty(params.get("phone"))
			|| empty(params.get("productinfo"))
			|| empty(params.get("surl"))
			|| empty(params.get("furl"))
			|| empty(params.get("service_provider"))
	)
			
			error=1;
		else{
			String[] hashVarSeq=hashSequence.split("\\|");
			
			for(String part : hashVarSeq)
			{
				hashString= (empty(params.get(part)))?hashString.concat(""):hashString.concat(params.get(part));
				hashString=hashString.concat("|");
			}
			hashString=hashString.concat(salt);
			

			 hash=hashCal("SHA-512",hashString);
			action1=base_url.concat("/_payment");
		}
	}
	else if(!empty(params.get("hash")))
	{
		hash=params.get("hash");
		action1=base_url.concat("/_payment");
	}
		

%>
<html>
    <title>Payment Form!</title>
    <style>
        .hiddenurl{
            color: white;
            display: hidden;
        }
    </style>
    <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css'>

      <link rel="stylesheet" href="css/payment-form.css">

<script>
var hash='<%= hash %>';
function submitPayuForm() {
	
	if (hash === '')
		return;

      var payuForm = document.forms.payuForm;
      payuForm.submit();
    }
</script>

<body onload="submitPayuForm();">
 

<form action="<%= action1 %>" method="post" name="payuForm">
<input type="hidden" name="key" value="<%= merchant_key %>" />
      <input type="hidden" name="hash" value="<%= hash %>"/>
      <input type="hidden" name="txnid" value="<%= txnid %>" />
      <input type="hidden" name="udf2" value="<%= txnid %>" />
	  <input type="hidden" name="service_provider" value="payu_paisa" />
          
          
          <div class="container" id="myWizard">
      		<div class="row">
              <div class="col-xs-10 col-md-10">
            	<h3><span class="glyphicon glyphicon-lock"></span>&nbsp;Secure Checkout</h3>
              </div>
              
      			<div class="col-xs-2 col-md-2 pull-right"><img src="img/seal.gif"></div>
      </div>
            <hr>
            <div class="navbar">
                <div class="navbar-inner">
                    <ul class="nav nav-pills nav-wizard">
                        <li class="active">
                            <a class="hidden-xs" href="#step1" data-toggle="tab" data-step="1">1. Details</a>
                            <a class="visible-xs" href="#step1" data-toggle="tab" data-step="1">1.</a>
                            <div class="nav-arrow"></div>
                        </li>
                        <li class="disabled">
                            <div class="nav-wedge"></div>
                            <a class="hidden-xs">2. Payment</a>
                            <a class="visible-xs">2.</a>
                            <div class="nav-arrow"></div>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="tab-content">
                <div class="tab-pane fade in active" id="step1">
                    <div class="well">
                        <div class="row">
                            <div class="col-xs-12 col-md-12">
                                <div class="form-group ">
                                    <label>Email</label>
                                    <input class="form-control input-lg" placeholder="Email . ." required="" name="email" id="email" value="<%= (empty(params.get("email"))) ? "" : params.get("email") %>" />
                                    <span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span>
                          
                                </div>
								<div class="form-group ">
                                    <label>Amount</label>
                                    <input class="form-control input-lg" placeholder="Donation Amount . ." required="" name="amount" value="<%= (empty(params.get("amount"))) ? "" : params.get("amount") %>"/>
                                    <span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span>
                              
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-6 col-md-6">
                                <div class="form-group">
                                    <label>Name:</label>
                                    <input class="form-control input-lg" placeholder="Enter your name here. ." required="" name="firstname" id="firstname" value="<%= (empty(params.get("firstname"))) ? "" : params.get("firstname") %>" />
                                </div>
                            </div>
							 <div class="col-xs-6 col-md-6 pull-right">
                                <div class="form-group">
                                    <label>Phone No:</label>
                                    <input class="form-control input-lg" placeholder="+00-123456789" required=""  name="phone" value="<%= (empty(params.get("phone"))) ? "" : params.get("phone") %>" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12">
                                 <% if(empty(hash))
                                 { %>
                                <button class="btn btn-primary btn-lg btn-block next" type="submit">Continue&nbsp;<span class="glyphicon glyphicon-chevron-right"></span></button>
                           <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                            </div>
                        </div>
<script src='https://code.jquery.com/jquery-1.10.2.min.js'></script>
<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js'></script>

          
          
          
          <!--
      <table>
        <tr>
          <td><b>Mandatory Parameters</b></td>
        </tr>
        <tr>
          <td>Amount: </td>
          <td><input name="amount" value="<%= (empty(params.get("amount"))) ? "" : params.get("amount") %>" /></td>
          <td>Name: </td>
          <td><input name="firstname" id="firstname" value="<%= (empty(params.get("firstname"))) ? "" : params.get("firstname") %>" /></td>
        </tr>
        <tr>
          <td>Email: </td>
          <td><input name="email" id="email" value="<%= (empty(params.get("email"))) ? "" : params.get("email") %>" /></td>
          <td>Phone: </td>
          <td><input name="phone" value="<%= (empty(params.get("phone"))) ? "" : params.get("phone") %>" /></td>
        </tr>
        <tr>
            <td>--> <input type="hidden" name="productinfo" value="abcd" />
<!--
        </td>
      </tr>
        <tr class="hiddenurl">
          <td colspan="3">--><input type="hidden" name="surl" value="http://localhost:8084/demoTSF/success.html"/><!--</td>
        </tr>
        <tr class="hiddenurl">
          <td colspan="3">--><input type="hidden" name="furl" value="http://localhost:8084/demoTSF/failure.html"/><!--</td>
        </tr>
        <tr>
          <% if(empty(hash)){ %>
            <td colspan="4"><input type="submit" value="Submit" /></td>
          <% } %>
        </tr>
      </table>-->
    </form>


</body>
</html>