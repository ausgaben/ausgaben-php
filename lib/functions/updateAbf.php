<?php

    /**
    * Update abf for account
    *
    * @param int        Account id
    * @return bool
    */
	function updateAbf ($account_id)
	{
		$Account = DB_DataObject::factory('account');
		if (!$Account->get($account_id)) return false;
		if (!$Account->enable_abf) return false;
		$Spending = DB_DataObject::factory('spending');
		$Spending->account_id = $account_id;
		$Spending->booked = 1;
		$Spending->orderBy('year');
		$Spending->orderBy('month');
		if ($Spending->find()) {
			$abf = array();
			while ($Spending->fetch()) {
				$yearmonth = sprintf('%d%02d', $Spending->year, $Spending->month);
				if (!isset($abf[$yearmonth])) $abf[$yearmonth] = 0;
				if ($Spending->type == SPENDING_TYPE_IN) {
					$abf[$yearmonth] += $Spending->value;
                } else {
                    $abf[$yearmonth] -= $Spending->value;
                }
			}
			$Account_abf = DB_DataObject::factory('account_abf');
			$Account_abf->account_id = $account_id;
			$Account_abf->delete();
			if (empty($abf)) return false;
			foreach ($abf as $yearmonth => $value) {
				if (isset($last_yearmonth)) {
					$abf[$yearmonth] += $abf[$last_yearmonth];
				}
				$last_yearmonth = $yearmonth;
			}
			foreach ($abf as $yearmonth => $value) {
				$Account_abf = DB_DataObject::factory('account_abf');
				$Account_abf->account_id = $account_id;
				$Account_abf->year = substr($yearmonth, 0, 4);
				$Account_abf->month = substr($yearmonth, 4, 2);
				$Account_abf->value = str_replace(',', '.', $value);
				$Account_abf->insert();
			}
            return true;
		}
	}
	
?>
