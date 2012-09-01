<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
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
    <link type="text/css" rel="stylesheet" href="/stylesheets/styles.css" />
  </head>

  <body>

<%
    String proverbCollectionName = request.getParameter("proverbCollectionName");
    if (proverbCollectionName == null) {
        proverbCollectionName = "default";
    }
    pageContext.setAttribute("proverbCollectionName", proverbCollectionName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name.</p>
<%
    }
%>

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key proverbKey = KeyFactory.createKey("ProverbCollection", proverbCollectionName);
    Query query = new Query("Proverb", proverbKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> proverbs = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10));
    if (proverbs.isEmpty()) {
        %>
        <p>Collection '${fn:escapeXml(proverbCollectionName)}' has no proverbs.</p>
        <%
    } else {
        %>
        <p>Proverbs in Collection '${fn:escapeXml(proverbCollectionName)}'.</p>
        <%
        for (Entity proverb : proverbs) {
            pageContext.setAttribute("proverb_content",
                                     proverb.getProperty("content"));
            %>
            <blockquote>${fn:escapeXml(proverb_content)}</blockquote>
            <%
        }
    }
%>

    <form action="/add" method="post">
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Add a Proverb" /></div>
      <input type="hidden" name="proverbCollectionName" value="${fn:escapeXml(proverbCollectionName)}"/>
    </form>

  </body>
</html>