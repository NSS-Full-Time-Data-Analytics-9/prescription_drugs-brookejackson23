--still going over to make sure correct--

--1. a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

SELECT SUM(total_claim_count) AS total_claims, npi
FROM prescription
LEFT JOIN prescriber
USING(npi)
GROUP BY npi
ORDER BY total_claims DESC
LIMIT 1;

--Answer: 99707 claims and npi is 1881634483.
	
--b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

SELECT SUM(total_claim_count) AS total_claims, npi, nppes_provider_last_org_name, nppes_provider_first_name, specialty_description
FROM prescription
LEFT JOIN prescriber
USING(npi)
GROUP BY npi, nppes_provider_last_org_name, nppes_provider_first_name, specialty_description
ORDER BY total_claims DESC
LIMIT 1;

--Answer: Bruce Pendley, Family Practice, with total claims as 99707 and npi is 1881634483.

--2. a. Which specialty had the most total number of claims (totaled over all drugs)?

SELECT specialty_description, SUM(total_claim_count) AS number_of_claims
FROM prescriber AS p1
INNER JOIN prescription AS p2
ON p1.npi = p2.npi
GROUP BY specialty_description
ORDER BY SUM(total_claim_count) DESC;

--Answer: Family Practice had 9,752,347 claims.

--b. Which specialty had the most total number of claims for opioids?

SELECT SUM(total_claim_count) AS claim_amount, specialty_description
FROM prescription
INNER JOIN prescriber
USING(npi)
INNER JOIN drug
USING(drug_name)
WHERE opioid_Drug_flag = 'Y'
GROUP BY specialty_description
ORDER BY claim_amount DESC;

--Answer: Nurse Practitioner with 900,845

--c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

--d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

--3. a. Which drug (generic_name) had the highest total drug cost?

SELECT SUM(total_drug_cost) AS drug_cost, generic_name
FROM drug
INNER JOIN prescription
USING(drug_name)
GROUP BY generic_name
ORDER BY drug_cost DESC;

--Answer: Insulin with cost $104,264,066.35

--b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

SELECT ROUND(SUM(total_drug_cost) / 365,2) AS pres_cost, generic_name
FROM drug
INNER JOIN prescription 
USING(drug_name)
GROUP BY generic_name
ORDER BY pres_cost DESC

--Answer: Insulin with $285,654.98

--4. a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

SELECT drug_name,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither' END AS drug_type
FROM drug;

--b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

SELECT SUM(total_drug_cost) AS money,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither' END AS drug_type
FROM drug
INNER JOIN prescription 
ON drug.drug_name = prescription.drug_name
WHERE opioid_drug_flag = 'Y' OR antibiotic_drug_flag = 'Y'
GROUP BY opioid_drug_flag, antibiotic_drug_flag

--Answer: More was spent on opioids which was $104,200,862.22 and $32,833,959.663 on antibiotics.

--5. a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

SELECT COUNT (cbsaname)
FROM cbsa
WHERE cbsaname ILIKE '%tn%'

--Answer: 58

--b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

SELECT cbsaname, 
population, 
cbsa, 
cbsa.fipscounty
FROM cbsa
INNER JOIN population
ON cbsa.fipscounty = population.fipscounty
GROUP BY population, cbsa, cbsa.fipscounty, cbsaname
ORDER BY population DESC;

--Answer: Largest Memphis, TN with population 937847, cbsa is 32820 and fipscounty is 47157

SELECT cbsaname, 
population, 
cbsa, 
cbsa.fipscounty
FROM cbsa
INNER JOIN population
ON cbsa.fipscounty = population.fipscounty
GROUP BY population, cbsa, cbsa.fipscounty, cbsaname
ORDER BY population;

--Lowest is fipscounty 47169 with cbsa as 34980, population 8773, and cbsaname is Nashville-Davidson--Murfreesboro--Franklin, TN

--c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

SELECT MAX(population) AS population, MAX(county) AS county_name
FROM fips_county
INNER JOIN population
ON fips_county.fipscounty = population.fipscounty;

--Answer: Wilcon County with 937,847 population

--6. a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

SELECT drug_name,
total_claim_count
FROM prescription
WHERE total_claim_count >= 2950
ORDER BY total_claim_count;

--Answer: The drug_name with 3023 claims is LEVOTHYROXINE SODIUM and OXYCODONE HCL had 2977 claims.

--b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

SELECT drug_name,
total_claim_count,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
	ELSE 'not_opioid' END AS drug_type
FROM prescription
INNER JOIN drug
USING(drug_name)
WHERE total_claim_count >= 2970
ORDER BY total_claim_count
LIMIT 2;

--c. Add another column to your answer from the previous part which gives the prescriber first and last name associated with each row.

SELECT drug_name,
total_claim_count,
nppes_provider_first_name,
nppes_provider_last_org_name,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
	ELSE 'not_opioid' END AS drug_type
FROM prescription
INNER JOIN drug
USING(drug_name)
INNER JOIN prescriber
ON prescription.npi = prescriber.npi
WHERE total_claim_count >= 2970
ORDER BY total_claim_count
LIMIT 2;

--The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Managment') in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

SELECT specialty_description, 
npi, 
drug_name,
nppes_provider_city
FROM prescriber
CROSS JOIN drug
WHERE nppes_provider_city = 'NASHVILLE' AND opioid_drug_flag = 'Y'

SELECT DISTINCT npi
FROM prescriber
CROSS JOIN drug
WHERE nppes_provider_city = 'NASHVILLE' AND opioid_drug_flag = 'Y'
GROUP BY drug_name, npi