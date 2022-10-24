import React, { useEffect, useState } from 'react';
import { createConsumer } from '@rails/actioncable';
import { Chart as ChartJS, registerables } from 'chart.js';
import { Line } from 'react-chartjs-2';

ChartJS.register(...registerables);
const consumer = createConsumer();

const RealtimeGraph = ({ slug }) => {
  const defaultDataChart = {
    labels: [],
    datasets: [{
      data: [],
    }],
  };
  const [graphInterval, setGraphInterval] = useState(5000);
  const [dataChart, setDataChart] = useState(defaultDataChart);
  const chartRef = React.useRef(null);
  const options = {
    responsive: true,
    plugins: {
      legend: {
        display: false,
      },
      title: {
        display: true,
        text: 'Realtime Visit Count',
      },
    },
    scales: {
      y: {
        title: {
          display: true,
          text: 'Number of visits',
        },
        beginAtZero: true,
        min: 0,
        suggestedMax: 10,
        ticks: {
          precision: 0,
        },
      },
      x: {
        title: {
          display: true,
          text: 'Intervals (MM:SS)',
        },
      },
    },
  };

  const combineLabels = (prevState, now) => {
    let labels = [...prevState, now];
    if (labels.length > 10) {
      labels = labels.slice(1);
    }
    return labels;
  };

  const combineData = (prevState, count) => {
    let data = [...prevState, count];
    if (data.length > 10) {
      data = data.slice(1);
    }
    return data;
  };

  const onChangeInterval = (interval) => {
    if (interval !== graphInterval) {
      setGraphInterval(interval);
      setDataChart(defaultDataChart);
    }
  };

  const IntervalButton = ({ interval, text }) => (
    <button
      type="button"
      className={`btn ${graphInterval === interval ? 'btn-selected' : ''}`}
      onClick={() => onChangeInterval(interval)}
    >
      {text}
    </button>
  );

  useEffect(() => {
    const urlVisitIntervalChannel = consumer.subscriptions.create({ channel: 'UrlVisitIntervalChannel', room: `url_visit_interval:${slug}` }, {
      received(data) {
        setDataChart((prevState) => ({
          labels: combineLabels(prevState.labels, data.now),
          datasets: [
            {
              label: 'Visit Count',
              data: combineData(prevState.datasets[0].data, data.count),
              borderColor: 'rgb(53, 162, 235)',
              backgroundColor: 'rgba(53, 162, 235, 0.5)',
              lineTension: 0.3,
            },
          ],
        }));
      },
    });

    const interval = setInterval(() => {
      urlVisitIntervalChannel.send({ slug, graph_interval: graphInterval });
    }, graphInterval);

    return () => {
      // Clear subscriptions, otherwise,
      // there will be duplicated subscription on each interval change
      consumer.subscriptions.remove(urlVisitIntervalChannel);
      clearInterval(interval);
    };
  }, [graphInterval]);

  return (
    <>
      <Line
        ref={chartRef}
        options={options}
        datasetIdKey="id"
        data={dataChart}
      />
      <div className="interval-btn-group-form">
        <IntervalButton interval={5000} text="5 seconds" />
        <IntervalButton interval={60000} text="1 minutes" />
        <IntervalButton interval={1800000} text="30 minutes" />
      </div>
    </>
  );
};
export default RealtimeGraph;
