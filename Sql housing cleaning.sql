SELECT * 
From PortfolioProject..NashvilleHousing

-----------------------






-- Standraize Data Format

SELECT SaleDate
From PortfolioProject..NashvilleHousing
	Update NashvilleHousing 
	Set SaleDate = Convert(Date,SaleDate)
-- Making sure it doesnt display time  in the date formate
	SELECT FORMAT(SaleDate, 'yyyy-MM-dd') AS saledateFormated
FROM PortfolioProject..NashvilleHousing;

-- trying some other way of removing time from Date
ALTER TABLE NashvilleHousing
ADD saledateconverted date;

Update NashvilleHousing 
	Set saledateconverted = Convert(Date,SaleDate)

	Select saledateconverted 
	from PortfolioProject..NashvilleHousing








-- Popuplate missing Data in (property Adresss Data) 

SELECT *
From PortfolioProject..NashvilleHousing 
Where PropertyAddress is null

-- creatine self join to fill in some null values 
Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing  a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null


Update a 
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	From PortfolioProject..NashvilleHousing  a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null


-- Breaking Address into (state,city,Address)

SELECT 
SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
 ,SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing 

-- Adding Address 
ALTER TABLE PortfolioProject..NashvilleHousing 
ADD PropertySplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
	Set PropertySplitAddress = SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 
-- Adding City 
ALTER TABLE PortfolioProject..NashvilleHousing 
ADD PropertySplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
	Set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) 




-- Another way of breadking down Address 

SELECT
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS ParsedOwnerAddress
	,PARSENAME(REPLACE(OwnerAddress, ',','.'),2) AS ParsedOwndercity,
	PARSENAME(REPLACE(OwnerAddress, ',','.'),1) AS ParsedOwnerState

FROM
    PortfolioProject..NashvilleHousing;


-- adding owner house tables
ALTER TABLE PortfolioProject..NashvilleHousing 
ADD OwnerSplitaddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
	Set  OwnerSplitaddresss =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 


	ALTER TABLE PortfolioProject..NashvilleHousing 
ADD OwnerSplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
	Set  OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',','.'),2)


ALTER TABLE PortfolioProject..NashvilleHousing 
ADD OwnerSplitState Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
	Set  OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)




	-- Changing Y and N into Yes and No 

Select SoldAsVacant, 
		Case When SoldAsVacant = 'Y' Then 'Yes'
			When SoldAsVacant = 'N' Then 'No'
			Else SoldAsVacant
			End

From PortfolioProject..NashvilleHousing
Update PortfolioProject..NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
			When SoldAsVacant = 'N' Then 'No'
			Else SoldAsVacant
			End

-- To check the change 
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2



Select * 
From PortfolioProject..NashvilleHousing


-- Remove Duplicates


WITH rowNumCTE AS (
SELECT *,
	ROW_NUMBER() Over ( 
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By UniqueID
				) Row_num
From PortfolioProject..NashvilleHousing 
)
--Select *
--From rowNumCTE
--where row_num > 1 

-- to delete extra 
Delete rowNumCTE
From rowNumCTE
Where Row_num>1 






-- Delete Unused Column could be for temp table anything 

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress 