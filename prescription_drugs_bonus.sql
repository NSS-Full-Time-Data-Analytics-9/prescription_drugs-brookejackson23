--1. How many npi numbers appear in the prescriber table but not in the prescription table?

SELECT prescriber.npi
FROM prescriber
LEFT JOIN prescription
ON prescriber.npi = prescription.npi
WHERE prescription.npi IS NULL

SELECT npi
FROM prescription
WHERE NOT EXISTS (SELECT npi
	FROM prescriber
	WHERE prescriber.npi = prescription.npi)
	
--2.a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.

SELECT drug_name, total_30_day_fill_count, generic_name, specialty_description
FROM prescription
INNER JOIN drug
USING (drug_name)
INNER JOIN prescriber
USING (npi)
WHERE specialty_description = 'Family Practice'
ORDER BY total_30_day_fill_count DESC

--Answer: "OXYCODONE HCL", "LISINOPRIL", "GABAPENTIN", "AMLODIPINE BESYLATE", "HYDROCODONE/ACETAMINOPHEN"

--c. Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists? Combine what you did for parts a and b into a single query to answer this question.

--3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.
--a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. Report the npi, the total number of claims, and include a column showing the city.

SELECT npi, drug_name, total_claim_count, nppes_provider_city
FROM prescription
INNER JOIN prescriber
USING(npi)
ORDER BY total_claim_count DESC
LIMIT 5;

--b. Now, report the same for Memphis.

SELECT npi, drug_name, total_claim_count, nppes_provider_city
FROM prescription
INNER JOIN prescriber
USING(npi)
WHERE nppes_provider_city = 'MEMPHIS'
ORDER BY total_claim_count DESC
LIMIT 5;

--c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.

SELECT npi, drug_name, total_claim_count, nppes_provider_city
FROM prescription
INNER JOIN prescriber
USING(npi)
WHERE nppes_provider_city = 'KNOXVILLE'
ORDER BY total_claim_count DESC
LIMIT 5;

SELECT npi, drug_name, total_claim_count, nppes_provider_city
FROM prescription
INNER JOIN prescriber
USING(npi)
WHERE nppes_provider_city = 'CHATTANOOGA'
ORDER BY total_claim_count DESC
LIMIT 5;

--4. Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.



	





