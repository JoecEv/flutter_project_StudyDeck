import express from 'express';
import bodyParser from 'body-parser';
import 'dotenv/config';

import deckRouter from './routes/deck_route';

const app = express();
app.use(bodyParser.json());
app.use(express.json());
app.use(deckRouter);

const port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`server started on port ${port}`);
});
