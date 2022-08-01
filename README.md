# Bellabeat-Case-Study
Google Data Analytics Capstone

<h2>INTRODUCTION</h2>
Bellabeat is a high-tech company that manufactures health-focused smart products for women. Their smart products collect data on activity, sleep, stress, and reproductive health. Bellabeat is a successful small company, with the potential to become a larger player in the global smart device market. 
<br />
<br />
In this case study I chose to focus on the Bellabeat App. The Bellabeat app, provides users with data relating to activity, sleep, stress, menstrual cycle, and mindfulness habits. The app connects to their line of smart wellness products. I plan to analyze smart device usage data to gain insight into how non-Bellabeat consumers use their smart devices.
<br />


<h2>ASK</h2>
<h4>Business Task</h4>
<ol>
<li> Analyze usage trends to identify opportunities for growth.</li>
<li> Identify what features have more engagement.</li>
<li> Identify activity trends.</li>
<li><a href="https://docs.google.com/document/d/1r7s6VpxifJ5_85hbu5IcIqzurBXF0aDFv6ClSFimPZA/preview">Scope of Work</a></li>
</ol>

<h4>Stakeholders</h4>
<ol>
<li>Urška Sršen: Bellabeat’s cofounder and Chief Creative Officer</li>
<li>Sando Mur: Mathematician and Bellabeat’s cofounder</li>
<li>Bellabeat marketing analytics team</li>
</ol>

<h2>PREPARE</h2>
<h4>Data Description</h4>
The <a href="https://www.kaggle.com/datasets/arashnic/fitbit">FitBit Fitness Tracker Data</a> (CC0: Public Domain, dataset made available through Mobius) contains 18 CSV files. The files contain health and fitness tracking information. Some other observations of the data: 
<ul>
  <li>The sample size is small. </li>
  <li>Demographic information is not provided. </li>
  <li>Data source mentions 30 users. However, 33 distinct user IDs were found. </li>
  <li>Data source mentions a time frame of 03.12.2016-05.12.2016. However, dataset has a time frame of  4.12.16-5.12.16. </li>
  <li>The data has combination of long and wide format. </li>
</ul>
Files were stored in local machine and uploaded to BigQuery for analysis. CSV files were also stored in Google Drive along with any new CSV files generated from SQL analysis.

<h2>PROCESS</h2>
<h4>Data Cleaning & Processing</h4>
I will be using: 
<ul>
<li>Google sheets → preview, format & clean</li>
<li><a href="http://www.fitabase.com/media/1930/fitabasedatadictionary102320.pdf">Fitabase Data Dictionary </a>→ analysis</li>
<li>SQL in BigQuery → analysis & computation</li>
<li>Tableau → data visualization</li>
<li>Notion → document data process</li>
<li>Google Slides → data presentation</li>
</ul>

Tasks performed:
<ul>
<li>Checked for duplicates. 3 duplicates found in sleep data.</li>
<li>Trimmed whitespace.</li>
<li>Verify activity minutes. Checked for sum of 1440 minutes.</li>
<li>Timestamps were split into date and time columns.</li>
<li>Column: "ActivityDate" changed to "Date"</li>
<li>Column: "ActivityDay" changed to "Date"</li>
<li>Date columns formatted.</li>
<li>Time columns formatted.</li>
</ul>


<h2>ANALYZE</h2>
Data was uploaded to BigQuery for <a href="https://github.com/ptorres1126/SQL-Bellabeat">SQL analysis.</a>

<h2>SHARE</h2>
<h4>Key Findings</h4>
Data findings, visualizations, and recommendations can be found in the <a href="http://docs.google.com/presentation/d/1CpozC_KeWlQ9Vlayq1Q-s66B0dImtPiHq0bBZ9W0tPk/preview">Bellabeat Case Study Presentation.

<h2>ACT</h2>
<h4>Conclusions</h4>
In this study, I wanted to focus on the Bellabeat App. I identified commonly used features and activity trends. The data tells us:
<ul>
<li>All 33 users were tracking their steps. </li>
<li>24 of the 33 users tracked their sleep. </li>
<li>Only 8 of the 33 users tracked their weight. </li>
<li>78% of users did not achieve a daily step average above 10,000 steps (CDC recommendation).</li>
<li>21% achieved a daily step average above 10,000 steps.</li>
<li>On average, more steps were taken on Tuesdays and Saturdays.</li>
<li>On average, less steps were taken on Sundays.</li>
<li>On average, users met the recommended amount of time exercising. (150 minutes per week. This could be 30 minutes per day for 5 days.)</li>
</ul>

<h4>Recommendations</h4>
I hypothesize that users had low step values with higher intensity minutes due to engaging in more stationary exercises. I also noticed that most of the weight tracking was completed manually. This suggests that perhaps inputting weight data may not be a user friendly task. However, it may also simply be an unpopular feature. More data is needed to determine the cause. The current assumption is that the weight tracking system needs to be a simpler user task. Based on these trends, I recommend the following: 
<ol>
<li><h5>Collect more data to have a more accurate analysis.</h5></li>
<li><h5>Encourage users to track stationary exercises in app.</h5> Perhaps use heart rate data to identify increased intensity when distance/steps are not increasing. Then use this to notify users and facilitate data input. </li>
<li><h5>Encourage users to use bluetooth scales for weight tracking.</h5></li>
<li><h5>Launch campaign with social media challenges to engage users in more physical activity.</h5>Perhaps include an incentive with access to certain features if users engage in a goal setting system within the app. Encourage users to post their steps/activity on their social profile.</li>
</ol>



<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
