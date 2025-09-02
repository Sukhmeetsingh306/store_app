import jwt from "jsonwebtoken";

export const sellerAuth = (req, res, next) => {
  const token = req.headers.authorization?.split(" ")[1];
  if (!token) {
    console.log("❌ No token provided");
    return res.status(401).json({ error: "No token provided" });
  }

  try {
    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET || "default_jwt_secret"
    );

    req.seller = {
      id: decoded.id,
      name: decoded.name,
      roles: decoded.roles,
      isSeller: decoded.isSeller,
    };

    console.log("🔹 Seller authenticated:", req.seller);
    next();
  } catch (e) {
    console.error("❌ Invalid token:", e);
    return res.status(401).json({ error: "Invalid token" });
  }
};
