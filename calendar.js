import "dotenv/config";
import cors from "cors";
import express from "express";
import { google } from "googleapis";

const app = express();
app.use(cors());
const oauth2Client = new google.auth.OAuth2(
  process.env.GOOGLE_CLIENT_ID,
  process.env.GOOGLE_CLIENT_SECRET,
  process.env.REDIRECT_URL
);

app.get("/", (req, res) => {
  const url = oauth2Client.generateAuthUrl({
    access_type: "offline",
    scope: "https://www.googleapis.com/auth/calendar.readonly",
  });

  res.redirect(url);
});

app.get("/redirect", (req, res) => {
  const code = req.query.code;

  oauth2Client.getToken(code, (err, tokens) => {
    if (err) {
      console.error("Couldn't get token", err);
      res.send("Token Error");
      return;
    }

    oauth2Client.setCredentials(tokens);

    res.send("Successfully logged in");
  });
});

app.post("/freebusy", express.json(), (req, res) => {
  console.log(req.body.calendar);
  const calendarId = req.body.calendar || "primary";

  const calendar = google.calendar({
    version: "v3",
    auth: process.env.GOOGLE_API_KEY,
  });

  const timeMin = new Date("12 February 2024").toISOString();
  const timeMax = new Date("14 February 2024").toISOString();

  calendar.freebusy.query(
    {
      resource: {
        timeMin,
        timeMax,
        items: [{ id: calendarId }],
      },
    },
    (err, response) => {
      if (err) {
        console.error("Can't fetch free/busy intervals");
        res.status(500).json({ error: "Error fetching free/busy intervals" });
        return;
      }

      const busyIntervals = response.data.calendars[calendarId].busy;
      res.json(busyIntervals);
    }
  );
});

app.listen(3000, () => console.log("Server running at 3000"));
