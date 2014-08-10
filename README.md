HEADS UP: This is the readme for a future release.

## About

Disclosed.ca is an open data initiative for the Canadian Government. 

This project scrapes third-party contract information from the websites of all 64 government agencies. The Proactive Disclosure

The goal is to promote transparency and accountability in the Canadian Government. We make it easy for journalists and academics to access third party contract information. There are 3 ways to access the data:

- Search engine: http://disclosed.ca
- CSV downloads: http://disclosed.ca/datasets
- JSON API: http://api.disclosed.ca


### What data is available?

We currently publish third party contract data.

In 2004 the Government announced a new policy on the mandatory publication of contracts over $10,000. Every single government agency is required to make this data available on a quarterly basis on their website. Here is an example for Environment Canada: http://www.ec.gc.ca/contracts-contrats/index.cfm?lang=En&state=reports.

The format of the contract data is dictated by these [guidelines](http://www.tbs-sct.gc.ca/pd-dp/dc/index-eng.asp)

## What other data are you planning to make available?

The Proactive Disclosure Act requires every agency to publish:

- [Grants and Contribution Awards over $25000](http://w03.international.gc.ca/dg-do/index.aspx?dept=1&lang=eng&p=3&r=39)
- [Completed Access to Information Requests](http://www.international.gc.ca/department-ministere/atip-aiprp/reports-rapports/2014/05-atip_aiprp.aspx?lang=eng) titles only - not the actual report :(
- [Travel and Hospitality Expenses for Employees](http://w03.international.gc.ca/dthe-dfva/report-rapport.aspx?lang=eng&dept=1&prof_id=469&ya=2014)
- [Annual Expenditures for Travel, Hospitality Conferences](http://www.international.gc.ca/department-ministere/transparency-transparence/travel_report_fa_2012-13-rapport_voyage_ae_2012-13.aspx?lang=eng)
- [Position Reclassifications](http://www.international.gc.ca/department-ministere/transparency-transparence/reclassification.aspx?lang=eng)


## Wait, I thought the government already has an Open Data initiative!

Yes, the open data website currently publishes 209,183 data sets. But there are a few problems:

- Incomplete data sets. For example, searching for 'contracts' only yields data for 3/64 agencies [link](http://data.gc.ca/data/en/dataset?q=contracts&sort=relevance+asc&page=2).
- Too many data formats. Data is served as CSV, PDF, XML, XLS, TXT and even JPEG.
- No APIs. In the modern web ecosystem JSON APIs are a must.
- Difficult for your average citizen to view the data.

The goal of this project is to organize the data sets in a way that makes sense.

