<?php

	/**
    * Handle Imports
    *
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Frontend
    */
	
	/**
	* This Import script is specified for handling the german Sparkasse
	* CVS-Format.
	*
	* TODO:
	* - Create a Import-Class
	* - Enable multiple import formats
	*/

	$Account = DB_DataObject::factory('account');
    $Account->orderBy('name');
    if ($Account->find()) {
        while ($Account->fetch()) {
            $DISPLAYDATA['accounts'][] = $Account->toArray();
        }
    }
    $account_id = getVar($_REQUEST['account_id'], 0);
    if (!$account_id) return;
    if ($ifsubmit) {
        $ifignoredrawings = getVar($_REQUEST['ifignoredrawings'], 0);
        require_once 'HTTP/Upload.php';
        $upload = new HTTP_Upload('de');
        $file = $upload->getFiles('file');
        if (PEAR::isError($file)) {
            die ($file->getMessage());
        }
        if ($file->isValid()) {
            $file->setName('uniq');
            $dest_dir = './var/upload/';
            $dest_name = $file->moveTo($dest_dir);
            if (PEAR::isError($dest_name)) {
                die ($dest_name->getMessage());
            }
            $real = $file->getProp('real');
            $cvs = "$dest_dir/$dest_name";
            $iffirstline = true;
            $line_append = '';
            $n_imported = 0;
            $n_failed = 0;
            foreach (file($cvs) as $line) {
                if ($iffirstline) {
                    $iffirstline = false;
                    continue;
                }
                if ($line_append != '') {
                    $line = $line_append.$line;
                    $line_append = '';
                }
                $fields = explode(';', str_replace('"', '', $line));
                if (count($fields) < 10) {
                    $line_append = $line;
                    continue;
                }
                if ($ifignoredrawings and $fields[2] == 'GELDAUTOMAT') continue;
                $Spending = DB_DataObject::factory('spending');
                $Spending->year  = 2000 + substr($fields[2], 6, 2);
                $Spending->month = substr($fields[2], 3, 2);
                $Spending->day   = substr($fields[2], 0, 2);
                $Spending->spendinggroup_id = 15; // Importiert vom Kontoauszug
                $Spending->spendingmethod_id = 3; // Überweisung
                $fields[4] = str_replace(',', ', ', $fields[4]);
                $Spending->description = preg_replace('/[0-9]{5,}/', '[n]', ucwords(strtolower((empty($fields[5])) ? $fields[4] : $fields[5].' - '.$fields[4])));
                $Spending->description = str_replace("\n", ' ', $Spending->description);
                $Spending->description = str_replace("\r", ' ', $Spending->description);
                $Spending->description = str_replace("\r\n", ' ', $Spending->description);
                $Spending->user_id = $_SESSION['user']['user_id'];
                $Spending->account_id = $account_id;
                $value = explode(',', $fields[8]);
                $value[0]  = str_replace('.', '', $value[0]);
                $value = join('.', $value);
                if ($value > 0) {
                    $Spending->type = SPENDING_TYPE_IN;
                } else {
                    $value = str_replace('-', '', $value);
                    $Spending->type = SPENDING_TYPE_OUT;
                }
                $Spending->value = $value;
                if ($Spending->insert()) {
                    $n_imported++;
                } else {
                    $n_failed++;
                }
                $DISPLAYDATA['n_imported'] = $n_imported;
                $DISPLAYDATA['n_failed'] = $n_failed;
                // Set Date of last import
                $date = new Date;
                $Account = DB_DataObject::factory('account');
                $Account->get($account_id);
                $Account->last_import = $date->getDate(DATE_FORMAT_TIMESTAMP);
                $Account->update();
            }
            unlink($cvs);
        } elseif ($file->isError()) {
            echo $file->errorMsg() . "\n";
        }
    }

?>
