package com.foodmart.dao;

import com.foodmart.config.FirebaseConfig;
import com.foodmart.model.User;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;

import java.util.ArrayList;
import java.util.List;

public class UserDao {

    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        try {
            Firestore db = FirebaseConfig.getDb();
            ApiFuture<QuerySnapshot> future = db.collection("users").get();
            List<QueryDocumentSnapshot> documents = future.get().getDocuments();
            if (documents != null) {
                for (QueryDocumentSnapshot doc : documents) {
                    User user = map(doc);
                    if (user != null) {
                        users.add(user);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public long count() {
        try {
            Firestore db = FirebaseConfig.getDb();
            ApiFuture<QuerySnapshot> future = db.collection("users").get();
            QuerySnapshot snapshot = future.get();
            if (snapshot != null && snapshot.getDocuments() != null) {
                return snapshot.getDocuments().size();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    private User map(DocumentSnapshot doc) {
        if (doc == null) return null;
        User u = new User();
        u.setUid(doc.getId());
        u.setName(doc.getString("name"));
        u.setEmail(doc.getString("email"));
        u.setPhone(doc.getString("phone"));
        u.setPassword(doc.getString("password"));
        u.setProfilePicUrl(doc.getString("profilePicUrl"));
        u.setAddress(doc.getString("address"));
        u.setCity(doc.getString("city"));
        try {
            Double lat = doc.getDouble("latitude");
            u.setLatitude(lat);
        } catch (Exception e) {
            u.setLatitude(null);
        }
        try {
            Double lng = doc.getDouble("longitude");
            u.setLongitude(lng);
        } catch (Exception e) {
            u.setLongitude(null);
        }
        return u;
    }
}
