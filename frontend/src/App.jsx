import { useState, useEffect } from 'react'
import axios from 'axios'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

function App() {
  const [data, setData] = useState([])

  const fetchData = async () => {
    try {
      // Taháme víc dat, aby graf vypadal jako graf (např. 50 bodů)
      const response = await axios.get('http://127.0.0.1:8000/history?limit=50')
      // Recharts potřebuje data v chronologickém pořadí (od nejstaršího po nejnovější)
      // Naše API vrací nejnovější první, tak to otočíme pomocí .reverse()
      setData(response.data.reverse())
    } catch (error) {
      console.error("Chyba při načítání dat:", error)
    }
  }

  useEffect(() => {
    fetchData()
  }, [])

  return (
    <div style={{ padding: '20px', backgroundColor: '#f9f9f9', minHeight: '100vh' }}>
      <h1>Vibrodiagnostický Dashboard</h1>
      
      <button onClick={fetchData} style={{ marginBottom: '20px', padding: '10px 20px', cursor: 'pointer' }}>
        Aktualizovat data
      </button>

      {/* SEKCE S GRAFEM */}
      <div style={{ width: '100%', height: 400, backgroundColor: 'white', padding: '20px', borderRadius: '8px', boxShadow: '0 2px 4px rgba(0,0,0,0.1)', marginBottom: '40px' }}>
        <h3>Trend RMS Vibrací</h3>
        <ResponsiveContainer width="100%" height="100%">
          <LineChart data={data}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis 
              dataKey="time" 
              tickFormatter={(timeStr) => new Date(timeStr).toLocaleTimeString()} 
            />
            <YAxis label={{ value: 'RMS [mm/s]', angle: -90, position: 'insideLeft' }} />
            <Tooltip labelFormatter={(label) => new Date(label).toLocaleString()} />
            <Legend />
            <Line type="monotone" dataKey="rms_raw" stroke="#8884d8" strokeWidth={2} dot={false} name="RMS Raw" />
          </LineChart>
        </ResponsiveContainer>
      </div>

      {/* TABULKA POD GRAFEM */}
      <h3>Detailní hodnoty</h3>
      <table border="1" style={{ width: '100%', borderCollapse: 'collapse', backgroundColor: 'white' }}>
        <thead>
          <tr style={{ backgroundColor: '#eee' }}>
            <th>Čas</th>
            <th>RMS Raw</th>
            <th>Peak Raw</th>
            <th>Kurtosis</th>
          </tr>
        </thead>
        <tbody>
          {/* V tabulce chceme vidět posledních 10 (otočíme zpět pro tabulku) */}
          {[...data].reverse().slice(0, 20).map((row, index) => (
            <tr key={index}>
              <td>{new Date(row.time).toLocaleString()}</td>
              <td>{row.rms_raw?.toFixed(3)}</td>
              <td>{row.peak_raw?.toFixed(3)}</td>
              <td>{row.kurtosis?.toFixed(3)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export default App