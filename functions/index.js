const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const firestore = admin.firestore();

/* eslint-disable indent */
exports.onUserStatusChange = functions.database
  .ref("/{uid}/active")
  .onUpdate((change, context) => {
    // Get the data from realtime database
    const isActive = change.after.val();
    // Get reference to cloud firestore
    const firestoreRef = firestore.doc(`users/${context.params.uid}`);
    // Update the value of the firestore database
    return firestoreRef.update({
      active: isActive,
      lastSeen: Date.now(),
    });
  });
