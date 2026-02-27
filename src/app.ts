import { Router, Request, Response } from 'express';
import { DataService } from './services/dataService';

const dataService = new DataService();
const router = Router();