package com.foodmart.dao;

import com.foodmart.config.FirebaseConfig;
import com.foodmart.model.Category;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CategoryDao {

    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        try {
            Firestore db = FirebaseConfig.getDb();
            ApiFuture<QuerySnapshot> future = db.collection("categories").get();
            List<QueryDocumentSnapshot> docs = future.get().getDocuments();
            if (docs != null) {
                for (QueryDocumentSnapshot doc : docs) {
                    Category c = map(doc);
                    if (c != null) {
                        categories.add(c);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    public long count() {
        try {
            Firestore db = FirebaseConfig.getDb();
            ApiFuture<QuerySnapshot> future = db.collection("categories").get();
            QuerySnapshot snapshot = future.get();
            if (snapshot != null && snapshot.getDocuments() != null) {
                return snapshot.getDocuments().size();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    /**
     * Case-insensitive duplicate check for category name.
     */
    public boolean existsByNameIgnoreCase(String name) {
        if (name == null) return false;
        String target = name.trim().toLowerCase();
        try {
            Firestore db = FirebaseConfig.getDb();
            ApiFuture<QuerySnapshot> future = db.collection("categories").get();
            QuerySnapshot snapshot = future.get();
            if (snapshot != null && snapshot.getDocuments() != null) {
                for (QueryDocumentSnapshot doc : snapshot.getDocuments()) {
                    String existingName = doc.getString("name");
                    if (existingName != null && existingName.trim().toLowerCase().equals(target)) {
                        return true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void addCategory(String name, String imageUrl, boolean active) {
        if (name == null) return;
        try {
            Firestore db = FirebaseConfig.getDb();
            Map<String, Object> data = new HashMap<>();
            data.put("name", name);
            data.put("imageUrl", imageUrl);
            data.put("active", active);
            db.collection("categories").add(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteCategory(String id) {
        if (id == null) return;
        try {
            Firestore db = FirebaseConfig.getDb();
            db.collection("categories").document(id).delete();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Category map(DocumentSnapshot doc) {
        if (doc == null) return null;
        Category c = new Category();
        c.setId(doc.getId());
        c.setName(doc.getString("name"));
        c.setImageUrl(doc.getString("imageUrl"));
        Boolean active = doc.getBoolean("active");
        c.setActive(active != null ? active : Boolean.FALSE);
        return c;
    }
}
