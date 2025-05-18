const { onCall } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

exports.deleteInstructorUser = onCall(
  {
    enforceAppCheck: false, // ✅ Requires App Check
  },
  async (request) => {
    // ✅ In v2, auth info is inside request.auth
    if (!request.auth) {
      throw new Error("The function must be called while authenticated.");
    }

    const userEmail = request.data.userEmail?.trim();

    if (!userEmail) {
      throw new Error("userEmail is required.");
    }

    try {
      const userRecord = await admin.auth().getUserByEmail(userEmail);
      const uid = userRecord.uid;

      await admin.auth().deleteUser(uid);
      await admin.firestore().collection('instructors').doc(uid).delete();

      return {
        success: true,
        message: `Instructor ${userEmail} deleted.`,
      };
    } catch (error) {
      console.error("Function error:", error.message);
      throw new Error(error.message || "Internal server error.");
    }
  }
);
exports.deleteCenter = onCall(
  {
    enforceAppCheck: false, // ✅ Requires App Check
  },
  async (request) => {
    // ✅ In v2, auth info is inside request.auth
    if (!request.auth) {
      throw new Error("The function must be called while authenticated.");
    }

    const userEmail = request.data.userEmail?.trim();

    if (!userEmail) {
      throw new Error("userEmail is required.");
    }

    try {
      const userRecord = await admin.auth().getUserByEmail(userEmail);
      const uid = userRecord.uid;

      await admin.auth().deleteUser(uid);
      await admin.firestore().collection('center').doc(uid).delete();

      return {
        success: true,
        message: `Instructor ${userEmail} deleted.`,
      };
    } catch (error) {
      console.error("Function error:", error.message);
      throw new Error(error.message || "Internal server error.");
    }
  }
);
