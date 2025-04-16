import express from "express"
import bodyParser from "body-parser"
import cors from "cors"
import { PrismaClient } from "./prisma/generated/prisma/client.js"

const app = express()
const PORT = 3000
const prisma = new PrismaClient()

app.use(bodyParser.json())
app.use(cors())

let transactions = []

app.post('/transactions', async (req, res) => {
  console.log("I got called")
  const { transactionId, paidPrice } = req.body

  if (!transactionId || !paidPrice) {
    return res.status(400).json({ error: 'Missing transactionId or paidPrice' })
  }

  try {
    const transaction = await prisma.transaction.create({
      data: {
        transactionId,
        transactionAmount: Number(paidPrice)
      }
    })

    transactions.push({ transactionId, paidPrice })
    console.log(transactions)

    return res.status(201).json(transaction)
  } catch (error) {
    return res.status(500).json({ error: "Something went wrong", detail: error.message })
  }
})

app.get('/transactions', async (req, res) => {
  try {
    const transactions = await prisma.transaction.findMany({
      select: {
        transactionId: true,
        transactionAmount: true
      }
    })
    return res.status(200).json(transactions)
  } catch (error) {
    console.error(error)
    res.status(500).json({error :"internal error"})
  }

})

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on http://localhost:${PORT}`)
})
