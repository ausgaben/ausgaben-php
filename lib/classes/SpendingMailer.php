<?php

    /**
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Backend
    */

    require_once 'lib/classes/SmartyPage.php';
    require_once 'Mail/mime.php';
    require_once 'Mail.php';
    
    /**
    * Class which sends spendings created by an user to other users of the accounts
    *
    * @author Markus Tacker <m@tacker.org>
    * @package Ausgaben
    * @subpackage Backend
    */
    class SpendingMailer
    {
        /**
        * @var object       User DataObject
        */
        var $_user;

        /**
        * @var object       Users DataObject
        */
        var $_users;

        /**
        * @var array        User's accounts
        */
        var $_accounts = array();

        /**
        * @var array        User's spendings
        */
        var $_spendings = array();

        /**
        * @var bool         Status
        */
        var $_status = false;
        
        /**
        * Sets the active user
        *
        * @param int        user id
        * @return bool
        */
        function setUser($user_id)
        {
            // Load user
            $User = DB_DataObject::factory('user');
            if (!$User->get($user_id)) {
                PEAR::raiseError("SpendingMailer::setUser() - User not found '$user_id'");
                return false;
            }
            $this->_user = $User;
            // Load user's accounts
            $User2Account = DB_DataObject::factory('user2account');
            $User2Account->user_id = $user_id;
            if (!$User2Account->find()) {
                PEAR::raiseError("SpendingMailer::setUser() - User '$user_id' has no accounts.");
                return false;
            }
            while ($User2Account->fetch()) {
                $Account = DB_DataObject::factory('account');
                if(!$Account->get($User2Account->account_id)) {
                    PEAR::raiseError("SpendingMailer::setUser() - Failed to fetch account '{$User2Account->account_id}'");
                    return false;
                }
                $this->_accounts[$Account->account_id] = $Account->toArray();
            }
            // Load spendings made by this user since his last login
            $Spending = DB_DataObject::factory('spending');
            $Spending->user_id = $user_id;
            $Spending->booked = 1;
            $Spending->whereAdd('account_id IN ('.join(',', array_keys($this->_accounts)).')');
            $Spending->whereAdd("timestamp > {$User->last_login}");
            $Spending->orderBy('account_id');
            $Spending->orderBy('type');
            $Spending->orderBy('spendinggroup_id');
            $Spending->orderBy('year desc');
            $Spending->orderBy('month desc');
            $Spending->orderBy('day desc');
            if (!$Spending->find()) {
                PEAR::raiseError("SpendingMailer::setUser() - User '$user_id' has no spendings.");
                return false;
            }
            while ($Spending->fetch()) {
                $Spending->getLinks();
                $spendingData = $Spending->toArray();
                $spendingData['date'] = sprintf('%04d%02d%02d000000', $Spending->year, $Spending->month, $Spending->day);
                $this->_spendings[] = $spendingData;
            }
            // Load users
            $User2Account = DB_DataObject::factory('user2account');
            $User2Account->whereAdd('account_id IN ('.join(',', array_keys($this->_accounts)).')');
            $User2Account->whereAdd("user_id != {$this->_user->user_id}");
            $User2Account->groupBy('user_id');
            if (!$User2Account->find()) {
                PEAR::raiseError("SpendingMailer::setUser() - There is no one to notfiy");
                return false;
            }
            while($User2Account->fetch()) {
                $User2Account->getLinks();
                $this->_users[] = $User2Account->_user_id;
            }
            $this->_status = true;
            return true;
        }

        /**
        * Starts the sending process
        *
        * @return bool
        */
        function send()
        {
            if (!$this->_status) return true;
            global $CONFIG;
            if (empty($this->_user)) {
                PEAR::raiseError("SpendingMailer::send() - Load a user first.");
                return false;
            }
            // Body erzeugen
            $body = $this->fetchBody();
            // Versenden
            $hdrs = array(
                'From' => "\"{$this->_user->prename} {$this->_user->name}\" <{$this->_user->email}>",
                'X-Ausgaben-Version' => $CONFIG['version'],
                'Subject' => "{$this->_user->prename} hat was ausgegeben!",
            );
            $mime = new Mail_Mime;
            // Bilder anhängen
            preg_match_all('/src="([^"]+)"/', $body, $matches);
            foreach ($matches[1] as $image) {
                switch (substr($image, -3, 3)) {
                case 'png':
                    $content_type = 'image/png';
                    break;
                case 'gif':
                    $content_type = 'image/gif';
                    break;
                default:
                    continue 2;
                }
                $body = str_replace($image, basename($image), $body);
                $mime->addHTMLImage($image, $content_type);
            }
            $mime->setHTMLBody($body);
            $body = $mime->get();
            $hdrs = array_merge($hdrs, $mime->headers());

            $mail =& Mail::factory('mail');
            foreach ($this->_users as $User) {
                $mail->send("\"{$User->prename} {$User->name}\" <{$User->email}>", $hdrs, $body);
            }
        }
        

        /**
        * Erzeugt den Body eines Mailings
        *
        * @return string|false
        */
        function fetchBody() 
        {
            global $DISPLAYDATA, $CONFIG;
            if (empty($this->_user)) {
                PEAR::raiseError("SpendingMailer::fetchBody() - Load a user first.");
                return false;
            }
            if (empty($this->_spendings)) {
                return false;
            }
            $DISPLAYDATA['css'] = file_get_contents('lib/css/ausgaben.css');
            $DISPLAYDATA['version'] = $CONFIG['version'];
            $DISPLAYDATA['user'] = $this->_user->toArray();
            $DISPLAYDATA['spendings'] = $this->_spendings;
            $SmartyPage = new SmartyPage;
            return $SmartyPage->fetch('mailing.tpl');
        }
    }

?>
