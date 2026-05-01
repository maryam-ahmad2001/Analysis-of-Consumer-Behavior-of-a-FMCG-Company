# Analysis-of-Consumer-Behavior-of-a-FMCG-Company

***Overview***
This project was completed as part of an internship at Sankhya Analytics, a real-world analytical research firm led by Mr. Vinayak Deshpande, alongside partners Gargi Rajadnya and Vedant Limaye under the guidance of our marketing professor Aditya Nagaraja. The study analysed real-time B2B data from 2018 and 2019 for an FMCG company that distributes its products through multiple Channel Partners. The goal was to understand consumer behavior, evaluate the effectiveness of a new product launch, and develop a data-driven communication strategy for future marketing campaigns.

***Objectives***

The project addressed three concrete business questions:

1. Identify which Channel Partners responded positively to the launch of a new product, and determine who to target first in the next planned campaign
2. Understand consumer behavior patterns for both Channel Partners (B2B) and end consumers (B2C)
3. Develop a scientifically grounded communication strategy for future campaigns based on what modes of outreach were most effective

***Dataset & Variables***
The dataset was sourced directly from the FMCG company via Sankhya Analytics and spanned 2018–2019. Key variables included:
Communication channels — SMS, Call, Email, Portal
Loyalty and Rewards membership indicators
Net Promoter Score (NPS)
Sales figures for 2018 and 2019
Buying Frequency and Buying Intervals
Active Partners count, Brand Engagement, Response Rate
Number of complaints and years of partnership
Region

***Methodology***

The project followed a four-stage analytical pipeline:

**Stage 1 — Data Management**
Multiple raw data files were compiled into a single master file. Basic data checks (dimension and structure validation) were applied, irrelevant columns were dropped, derived variables were engineered (including Sales 2019 and NPS as composite variables), and all files were merged into a clean analytical dataset.

**Stage 2 — Descriptive Statistics & Data Visualisation**
IBM SPSS was used to produce visualisations of response rates by communication factor, complaint distributions, NPS distributions, years of partnership, and sales trends. A correlation heatmap revealed high multicollinearity involving the SMS variable, which was subsequently removed from the predictive modelling stage.

**Stage 3 — Predictive Modelling**
Logistic regression was applied with Channel Partner response (Yes/No) as the binary dependent variable. The model identified the following statistically significant predictors of a positive response:
Email — significant positive effect
Call — significant positive effect
Loyalty membership — significant positive effect
Rewards redemption — significant positive effect
Sales 2019 (derived variable) — significant
NPS (derived variable) — significant
Variance Inflation Factor (VIF) checks confirmed all variables fell below 5, indicating no multicollinearity in the final model.

**Stage 4 — Text Mining**
Customer review text was analysed using a structured text mining pipeline: raw text was imported and converted into a corpus, cleaned, inspected for frequency terms, and visualised as a word cloud and bar chart. Associated word matrices were also generated. The word cloud revealed that the most frequently used terms in end-consumer reviews were coffee, taste, flavor, like, and good — indicating predominantly positive sentiment toward the product.

**Key Findings & Conclusions**
**Conclusion 1 — New Product Launch Response**
A list of Channel Partners that responded positively to the new product launch was identified. These partners represent the primary targets for the company's next planned campaign.
**Conclusion 2 — Consumer Behavior Drivers**
Channel Partners with loyalty membership and higher rewards redemption rates were significantly more likely to respond positively to new product launches. Recommendations were made to strengthen Channel Partner relationships through flexible payment terms (part payment, extra credit, balance arrangements). For end consumers, product flavor was the dominant driver of engagement — with recipe-based content identified as a high-engagement format.
**Conclusion 3 — Scientific Communication Strategy**
The analysis confirmed that Call, SMS, and Email (all coded as 1 — active use) were the most effective communication channels. A standardised, multi-channel communication framework was recommended for future campaigns.

**COVID-19 Strategic Addendum**
Since the dataset predated COVID-19, the team was also asked to develop strategies suited to the pandemic context. The core recommendation was a dual approach: direct-to-consumer (D2C) engagement to reduce dependence on Channel Partners, combined with efforts to strengthen existing Channel Partner relationships. Specific tactics recommended included:
SEO/SEM — search engine optimisation and marketing to drive organic and paid discovery
Website development — building a D2C channel to connect directly with end consumers
Social Media Marketing (SMM) — leveraging Facebook, Instagram, Twitter, YouTube, and LinkedIn

**Case Study — Country Bean**
Country Bean, India's first flavoured coffee brand (founded 2017), was used as a benchmarking case study. The brand's D2C model, Instagram presence of nearly one million followers, and use of recipe content, reels, and memes for brand engagement were highlighted as a replicable digital-first strategy for the FMCG client.

***Tools & Technologies***
IBM SPSS — logistic regression, visualisation, descriptive statistics
R - primary language for data cleaning, feature engineering, regression, modelling, corpus analysis and text mining
Microsoft Excel — data management and master file compilation
