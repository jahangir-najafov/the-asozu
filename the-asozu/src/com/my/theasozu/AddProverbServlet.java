package com.my.theasozu;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AddProverbServlet extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        String proverbCollectionName = req.getParameter("proverbCollectionName");
        Key proverbKey = KeyFactory.createKey("ProverbCollection", proverbCollectionName);
        String content = req.getParameter("content");
        String language = null;
        String category = null;
        String source = null;
        String definition = null;
        Integer numberOfLikes = 0;
        Date date = new Date();
        Entity proverb = new Entity("Proverb", proverbKey);
        proverb.setProperty("content", content);
        proverb.setProperty("language", language);
        proverb.setProperty("category", category);
        proverb.setProperty("source", source);
        proverb.setProperty("definition", definition);
        proverb.setProperty("numberOfLikes", numberOfLikes);
        proverb.setProperty("user", user);
        proverb.setProperty("date", date);

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(proverb);

        resp.sendRedirect("/the-asozu.jsp?proverbCollectionName=" + proverbCollectionName);
    }
}