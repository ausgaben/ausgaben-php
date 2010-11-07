<?php

    /**
    * Handle Spendings
    *
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Frontend
    */

    $order_by_date = $Settings->get('order_by_date');

    $DateLastLogin = new Date($_SESSION['user']['last_login']);

    // Load abf (amount brought forward)
    $abf = array();
    $Account_abf = DB_DataObject::factory('account_abf');
    if ($Account_abf->find()) {
        while ($Account_abf->fetch()) {
            $abf[$Account_abf->account_id][sprintf('%d%02d', $Account_abf->year, $Account_abf->month)] = $Account_abf->value;
        }
    }
    // Load Accounts
    $User2Account = DB_DataObject::factory('user2account');
    $User2Account->user_id = $_SESSION['user']['user_id'];
    if (!$User2Account->find()) return;
   	while ($User2Account->fetch()) {
        $Account = $User2Account->getLink('account_id');

        if (!$Account) continue;
        $AccountData = $Account->toArray();
        $AccountData['sum_value'] = 0;
        // Load Values
        $SpendingValue = DB_DataObject::factory('spending');
        $SpendingValue->groupBy('type');
        $SpendingValue->selectAdd('SUM(value) as sum_value');
        $SpendingValue->whereAdd('account_id='.$Account->account_id);
        $SpendingValue->whereAdd('booked=1');
        if ($Account->summarize_months) {
            $SpendingValue->whereAdd('month='.intval(substr($display_month, 4, 2)));
            $SpendingValue->whereAdd('year='.substr($display_month, 0, 4));
        }
        if ($SpendingValue->find()) {
            while ($SpendingValue->fetch()) {
                if ($SpendingValue->type == SPENDING_TYPE_IN) {
                    $AccountData['sum_value'] += $SpendingValue->sum_value;
                } else if ($SpendingValue->type == SPENDING_TYPE_OUT) {
                    $AccountData['sum_value'] -= $SpendingValue->sum_value;
                }
            }
        }
        $DISPLAYDATA['accounts'][$Account->account_id] = $AccountData;
	}


    if(!$account_id) return;
    if (isset($DISPLAYDATA['accounts'][$account_id])) {
        $activeAccount = $DISPLAYDATA['accounts'][$account_id];
    } else {
        return;
    }
    // Insert new spending
    if ($ifsubmit) {
        $spending_id        = getVar(&$_REQUEST['spending_id'], 0);
        $spendinggroup_id   = getVar(&$_REQUEST['spendinggroup_id'], 0);
        $spendinggroup_name = getVar(&$_REQUEST['spendinggroup_name'], '');
        $Spending = DB_DataObject::factory('spending');
        if ($spending_id and !$ifduplicate) {
            if (!$Spending->get($spending_id)) {
                return;
            }
        }
        // Delete spending
        if ($ifdelete and $spending_id) {
            $Spending->delete();
            updateAbf($account_id);
            $relocateDo = 'spendings';
            return;
        }
        // Neue Werte setzen
        $Spending->setFrom($_REQUEST);
        $Spending->value = str_replace(',', '.', trim($Spending->value));
        if ($Spending->value < 0) {
            $Spending->value = $Spending->value * -1;
            $Spending->type = SPENDING_TYPE_OUT;
        }
        $Spending->user_id = $_SESSION['user']['user_id'];
        $Spending->date = sprintf('%04d%02d%02d', $_REQUEST['year'], $_REQUEST['month'], $_REQUEST['day']);
        // If no spendinggroup_id isset maybe we should create a new one?
        // -> spendinggroup_name must be set
        if (empty($spendinggroup_id) and !empty($spendinggroup_name)) {
            $Spendinggroup = DB_DataObject::factory('spendinggroup');
            $Spendinggroup->name = trim($spendinggroup_name);
            $result = $Spendinggroup->find();
            if ($result <= 0) {
                $result = $Spendinggroup->insert();
                if (!$result) {
                    echo "Failed to create new spendinggroup";
                    die();
                }
                $spendinggroup_id = $result;
            } else {
                $Spendinggroup->fetch();
                $spendinggroup_id = $Spendinggroup->spendinggroup_id;
            }
            $Spending->spendinggroup_id = $spendinggroup_id;
        }
        if ($spending_id and !$ifduplicate) {
            $result = $Spending->update();
        } else {
            $result = $Spending->insert();
            $spending_id = $result;
        }
        if (!$result) {
            if (PEAR::isError($result)) {
                echo "Failed to insert spending.";
                die();
            }
        }
        updateAbf($account_id);
        $relocateDo = 'spendings';
        $relocateId = $spending_id;
    }
    // Load Spendinggroups
    $Spendinggroup = DB_DataObject::factory('spendinggroup');
    $Spendinggroup->orderBy('name');
    if ($Spendinggroup->find()) {
        while($Spendinggroup->fetch()) {
            $DISPLAYDATA['spendinggroups'][$Spendinggroup->spendinggroup_id] = $Spendinggroup->toArray();
            $DISPLAYDATA['spendinggroups'][$Spendinggroup->spendinggroup_id]['sum'] = 0;
        }
    }
    if ($activeAccount['summarize_months']) {
        // Load months
        $Spending = DB_DataObject::factory('spending');
        $Spending->orderBy('year desc');
        $Spending->orderBy('month desc');
        $Spending->groupBy('year, month');
        $Spending->booked = 1;
        $Spending->account_id = $account_id;
        if ($Spending->find()) {
            while ($Spending->fetch()) {
                $DISPLAYDATA['months'][] = sprintf('%04d%02d01000000', $Spending->year, $Spending->month);
            }
        }
    }
    // Load not booked spendings
    $Spending = DB_DataObject::factory('spending');
    if (!$order_by_date) $Spending->orderBy('spendinggroup_id');
    $Spending->orderBy('year desc');
    $Spending->orderBy('month desc');
    $Spending->orderBy('day desc');
    $Spending->booked = 0;
    $Spending->account_id = $account_id;
    if ($activeAccount['summarize_months']) {
    	$Spending->whereAdd('month='.intval(substr($display_month, 4, 2)));
    	$Spending->whereAdd('year='.substr($display_month, 0, 4));
   	}
    if ($Spending->find()) {
        $DISPLAYDATA['sum_notbooked'] = 0;
        while ($Spending->fetch()) {
            $spendingData = $Spending->toArray();
            $spendingData['date'] = sprintf('%04d%02d%02d000000', $Spending->year, $Spending->month, $Spending->day);
            $DISPLAYDATA['spendings_notbooked'][] = $spendingData;
            if ($Spending->type == SPENDING_TYPE_IN) {
                $DISPLAYDATA['sum_notbooked'] += $Spending->value;
                $DISPLAYDATA['spendinggroups'][$Spending->spendinggroup_id]['sum_notbooked'] += $Spending->value;
            } else if ($Spending->type == SPENDING_TYPE_OUT) {
                $DISPLAYDATA['sum_notbooked'] -= $Spending->value;
                $DISPLAYDATA['spendinggroups'][$Spending->spendinggroup_id]['sum_notbooked'] -= $Spending->value;
            }
        }
    }
    // Load sums per month
    if ($activeAccount['summarize_months']) {
        $DISPLAYDATA['month_sums'] = array();
        $DISPLAYDATA['month_sums']['_all'] = 0;
        if (!isset($DISPLAYDATA['months'])) return;
        foreach ($DISPLAYDATA['months'] as $date) {
            $DISPLAYDATA['month_sums'][$date] = 0;
		// Display only current years month sums
		if ((int)substr($date, 0, 4) < (int)strftime('%Y')) {
                        $DISPLAYDATA['month_sums'][$date] = false;
			continue;
		}
            $Spending = DB_DataObject::factory('spending');
            $Spending->year = substr($date, 0, 4);
            $Spending->month = substr($date, 4, 2);
            $Spending->groupBy('type');
            $Spending->selectAdd('SUM(value) as sum');
            $Spending->booked = 1;
            $Spending->account_id = $account_id;
            if ($Spending->find()) {
                while ($Spending->fetch()) {
                    if ($Spending->type == SPENDING_TYPE_IN) {
                        $DISPLAYDATA['month_sums'][$date] += $Spending->sum;
                        $DISPLAYDATA['month_sums']['_all'] += $Spending->sum;
                    } else if ($Spending->type == SPENDING_TYPE_OUT or $Spending->type == SPENDING_TYPE_WITHDRAWAL) {
                        $DISPLAYDATA['month_sums'][$date] -= $Spending->sum;
                        $DISPLAYDATA['month_sums']['_all'] -= $Spending->sum;
                    }
                }
            }
        }
        // Load abf
        if ($activeAccount['enable_abf'] and !empty($abf[$account_id])) {
            foreach ($abf[$account_id] as $abf_yearmonth => $value) {
                $abf_date = strftime('%Y%m01000000', mktime(0, 0, 0, substr($abf_yearmonth, 4, 2) + 1, 1, substr($abf_yearmonth, 0, 4)));
                if (isset($DISPLAYDATA['month_sums'][$abf_date])) $DISPLAYDATA['month_sums_abf'][$abf_date] = $DISPLAYDATA['month_sums'][$abf_date] + $value;
            }
        }
    }

    // Load Spendings
    $DISPLAYDATA['sum_type'] = array(
        SPENDING_TYPE_ACCOUNT       => 0,
        SPENDING_TYPE_OUT           => 0,
        SPENDING_TYPE_IN            => 0,
        SPENDING_TYPE_CASH          => 0,
        SPENDING_TYPE_WITHDRAWAL    => 0,
    );
    $Spending = DB_DataObject::factory('spending');
    if (!$order_by_date) $Spending->orderBy('spendinggroup_id');
    $Spending->booked = 1;
    if ($activeAccount['summarize_months']) {
        $Spending->orderBy('day desc');
        $Spending->whereAdd('month='.intval(substr($display_month, 4, 2)));
        $Spending->whereAdd('year='.substr($display_month, 0, 4));
    } else {
        $Spending->orderBy('year asc');
        $Spending->orderBy('month asc');
        $Spending->orderBy('day asc');
    }
    $Spending->whereAdd("account_id=$account_id");

    if ($Spending->find()) {
        while ($Spending->fetch()) {
            $spendingData = $Spending->toArray();
            $SpendingDate = new Date(sprintf('%04d-%02d-%02d', $Spending->year, $Spending->month, $Spending->day));
            $spendingData['date'] = $SpendingDate->format('%Y%m%d000000');
            if ($DateLastLogin->before($SpendingDate) and $Spending->user_id != $_SESSION['user']['user_id']) {
                $spendingData['is_new'] = true;
            } else {
                $spendingData['is_new'] = false;
            }
            if ($spending_config[$Spending->type]['value'] > 0) {
                $DISPLAYDATA['sum_type'][$Spending->type] += $Spending->value;
                $DISPLAYDATA['spendinggroups'][$Spending->spendinggroup_id]['sum'] += $Spending->value;
            } else  {
                $DISPLAYDATA['sum_type'][$Spending->type] -= $Spending->value;
                $DISPLAYDATA['spendinggroups'][$Spending->spendinggroup_id]['sum'] -= $Spending->value;
            }
            switch ($Spending->type) {
            case SPENDING_TYPE_OUT:
            case SPENDING_TYPE_IN:
            case SPENDING_TYPE_WITHDRAWAL:
                $DISPLAYDATA['spendings'][] = $spendingData;
                break;
            case SPENDING_TYPE_CASH:
                $DISPLAYDATA['spendings_cash'][] = $spendingData;
                break;
            }
        }
        // Gesamtsummen
        $DISPLAYDATA['sum_type'][SPENDING_TYPE_OUT] += $DISPLAYDATA['sum_type'][SPENDING_TYPE_WITHDRAWAL];
        $DISPLAYDATA['sum_type'][SPENDING_TYPE_ACCOUNT] = $DISPLAYDATA['sum_type'][SPENDING_TYPE_OUT] + $DISPLAYDATA['sum_type'][SPENDING_TYPE_IN];
        // Gruppensummen
        $DBC = $Spending->getDataBaseConnection();
        $result = $DBC->getAll('SELECT b.spendinggroup_id, b.name , SUM((CASE WHEN a.type=2 THEN a.value ELSE - a.value END)) AS sum FROM spending a LEFT JOIN spendinggroup b ON b.spendinggroup_id=a.spendinggroup_id WHERE a.account_id=' . $account_id . ' AND a.booked = 1 GROUP BY spendinggroup_id');
        $DISPLAYDATA['spendinggroups_sums'] = array();
        foreach ($result as $row) {
            $DISPLAYDATA['spendinggroups_sums'][$row[0]] = array(
                'name' => $row[1],
                'sum' => $row[2],
            );
        }
    }

    // Load abf from last month
    if ($activeAccount['enable_abf'] and !empty($abf[$account_id])) {
        $last_month = strftime('%Y%m', mktime(0, 0, 0, substr($display_month, 4, 2) - 1, 1, substr($display_month, 0, 4)));
        if (isset($abf[$account_id][$last_month])) {
            $DISPLAYDATA['abf'] = array(
                'value' => $abf[$account_id][$last_month],
                'date' => mktime(0, 0, 0, substr($last_month, 4, 2), 1, substr($last_month, 0, 4)),
            );
            $DISPLAYDATA['sum_abf'] = $DISPLAYDATA['sum_type'][SPENDING_TYPE_ACCOUNT] + $abf[$account_id][$last_month];
        }
        // Set Date of the abf sum
        $date_now     = new Date;
        $date_display = new Date(mktime(0, 0, 0, substr($display_month, 4, 2), 1, substr($display_month, 0, 4)));
        if ($date_now->format('%Y%m') == $date_display->format('%Y%m')) {
            $DISPLAYDATA['sum_abf_date'] = $date_now->getDate(DATE_FORMAT_UNIXTIME);
        } else {
            $DISPLAYDATA['sum_abf_date'] = mktime(23, 59, 59, $date_display->getMonth() + 1, 0, $date_display->getYear());
        }
    }
    // Einstellungen
    $DISPLAYDATA['summarize_months'] = $activeAccount['summarize_months'];
    $DISPLAYDATA['spending_config'] = $spending_config;
    // Beschreibungen laden
    $date_1month = new Date;
    $date_1month->subtractSeconds(4 * 31 * 24 * 60 * 60);
    $Spending = DB_DataObject::factory('spending');
    $Spending->whereAdd('timestamp > ' . $date_1month->getDate(DATE_FORMAT_TIMESTAMP));
    $Spending->orderBy('spendinggroup_id');
    $Spending->orderBy('description');
    if ($Spending->find()) {
        $DISPLAYDATA['descriptions'] = array();
        while ($Spending->fetch()) {
            $description = trim($Spending->description);
            if (empty($description)) continue;
            $DISPLAYDATA['descriptions'][$Spending->spendinggroup_id][] = $description;
        }
    }
    $SpendingFilter = SpendingFilter::factory($CONFIG['spending_filter']);
    $SpendingFilter->filterDescriptions(&$DISPLAYDATA['descriptions']);
