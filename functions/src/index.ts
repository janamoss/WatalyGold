import * as admin from "firebase-admin";
// import * as express from "express";
import axios from "axios";
import * as functions from "firebase-functions";
import * as https from "https";
// import {serviceAccount} from "./confic/firebase";

admin.initializeApp({
  credential: admin.credential.cert({
    privateKey: functions.config().private.key.replace(/\\n/g, "\n"),
    projectId: functions.config().project.id,
    clientEmail: functions.config().client.email,
  }),
  databaseURL: "https://watalygold-default-rtdb.firebaseio.com/",
});
const apiUrl = "https://dataapi.moc.go.th/gis-product-prices?product_id=W14024&from_date=2018-01-01&to_date=2025-02-28";


axios.get(apiUrl, {httpsAgent: new https.Agent(
  {rejectUnauthorized: false})})
  .then((response) => {
    const data = response.data;
    data.price_list.forEach((_item: {date: string | number | Date;}) => {
      const timestamp = admin.firestore.Timestamp.fromDate(
        new Date(_item.date));
      const newDate = timestamp.toDate().toLocaleDateString();
      _item.date = newDate;
    });
    const db = admin.firestore();
    const docRef = db.collection("ExportPrice").doc("new_ExportPrice");
    docRef.set(data)
      .then(() => {
        console.log("Successfully saved data to Firebase.");
      })
      .catch((error) => {
        console.error("An error occurred while saving data:", error);
      });
  })
  .catch((error) => {
    console.error("Error accessing API:", error);
  });
