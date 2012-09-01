<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Random" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	
	<link type="text/css" rel="stylesheet" href="style.css" />
	<title>ASozu - Collection of Proverbs</title>
</head>
<body>
	<div class="wrapper" id="header">
	<div class="dc_container">
	<div id="sub-header">
		<div class="div-centered" id="logo-link">
			<a href="index.jsp">the-asozu</a>
		</div>	
		<div class="div-centered" id="top-bar">
			&nbsp;&nbsp;&nbsp;&nbsp;<a href="popular.jsp">məşhur</a>
			&nbsp;&nbsp;&nbsp;&nbsp;<a href="latest.jsp">yeni</a>
			&nbsp;&nbsp;&nbsp;&nbsp;<a href="">filter</a>
			&nbsp;&nbsp;&nbsp;&nbsp;<a href="addProverb.jsp">əlavə<!--/redaktə--></a>
		</div>
	</div>
	</div>
	</div>
	
	<div id="list-proverb">
	<%
		String proverbCollectionName = "default";
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Key proverbKey = KeyFactory.createKey("ProverbCollection", proverbCollectionName);
    	Query query = new Query("Proverb", proverbKey).addSort("date", Query.SortDirection.DESCENDING);
	    List<Entity> proverbs = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(100));
    	if (proverbs.isEmpty())
    	{
    %>
    		<p>Collection '${fn:escapeXml(proverbCollectionName)}' has no proverbs.</p>
    <%
    	} 
    	else
    	{
        	for (Entity proverb : proverbs)
        	{
            	pageContext.setAttribute("proverb_content", proverb.getProperty("content"));
    %>
            	<div class="proverb-container"><p>${fn:escapeXml(proverb_content)}</p></div>
    <%
        	}
    	}
	%>
	</div>
	
</body>
</html>