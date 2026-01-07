import { useState, useEffect } from 'react'
import axios from 'axios'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

function App() {
  const [data, setData] = useState([])
  const [diagnosis, setDiagnosis] = useState(null);
  const [loading, setLoading] = useState(false);

  // Data pro graf
  const fetchData = async () => {
    try {
      const response = await axios.get('http://127.0.0.1:8000/history?limit=50')
      setData(response.data.reverse())
    } catch (error) {
      console.error("Chyba při načítání dat:", error)
    }
  }

  useEffect(() => {
    fetchData();
  }, [])

  // Funkce diagnostiky
  const runDiagnosis = async () => {
    if (data.length == 0) return;
    setLoading(true);
    const latest=data[data.length-1];
    try {
      console.log("Posílám k analýze:", {
        rms: latest.rms_raw,
        kurtosis: latest.kurtosis,
        ptp: latest.peak_raw
      });
      const response = await axios.post('http://127.0.0.1:8001/predict', {
        rms: latest.rms_raw,
        kurtosis: latest.kurtosis,
        ptp: latest.peak_raw
      });
      setDiagnosis(response.data);
    } catch (error) {
      console.error("Diagnostika selhala:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ padding: '20px', backgroundColor: '#ffffffff', minHeight: '100vh', fontFamily: 'sans-serif' }}>
      <h1>Vibrodiagnostický Dashboard</h1>
      
      <div style={{ marginBottom: '20px' }}>
        <button onClick={fetchData} style={{ marginRight: '10px', padding: '10px 20px' }}>Aktualizovat data</button>
        
        <button 
          onClick={runDiagnosis} 
          disabled={loading}
          style={{ 
            padding: '10px 20px', 
            backgroundColor: '#007bff', 
            color: 'white', 
            border: 'none', 
            borderRadius: '4px',
            cursor: 'pointer'
          }}
        >
          {loading ? 'Analyzuji...' : 'Spustit AI Diagnostiku'}
        </button>
      </div>

      {/* PANEL DIAGNOSTIKY */}
      {diagnosis && (
        <div style={{ 
          padding: '20px', 
          marginBottom: '20px', 
          borderRadius: '8px', 
          color: 'white',
          backgroundColor: diagnosis.label === 1 ? '#d9534f' : '#5cb85c',
          boxShadow: '0 4px 6px rgba(0,0,0,0.1)'
        }}>
          <h2 style={{ margin: 0 }}>Stav stroje: {diagnosis.status}</h2>
          <p style={{ margin: '5px 0 0 0' }}>
            Jistota modelu: {(diagnosis.confidence * 100).toFixed(1)}% | 
            Parametry: RMS={data[data.length-1].rms_raw.toFixed(2)}, 
            Kurt={data[data.length-1].kurtosis.toFixed(2)}
          </p>
        </div>
      )}

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