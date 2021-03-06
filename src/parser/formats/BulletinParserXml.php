<?php

if (!defined('BASE_PATH'))
	die();
	
class BulletinParserXml {
	public $parent = null;
	
	public function __construct($parent){
		$this->parent = $parent;
	}
	
	// init 
	public function loadRootNode($content){
		try {
			return new SimpleXMLElement($content);
		} catch (Exception $e){
			return new KaosError('XML Exception: '.$e->getMessage());//.print_r($e, true));
		}
	}
	/*
	public function select($childConfig, $node, $rootNode){
		$childConfigSelector = is_string($childConfig) ? $childConfig : $childConfig->selector;
		
		if (substr($childConfigSelector, 0, 2) == './'){
			if (!$node)
				return 'bad selector '.$childConfigSelector;
			return $this->getNodeChild($node, substr($childConfigSelector, 2));
		} else
			return $this->getNode($rootNode, $childConfigSelector);
	}
*/
	public function isSelector($selector){
		return property_exists($selector, 'selector');
	}
	
	public function getValueBySelector($selector, $childConfig, $node, $rootNode, $isChild = false){
		$oselector = $selector;
		
		if (is_object($selector))
			$selector = $selector->selector;

		if ($selector == '.')
			//return print_r($node, true);//
			return $this->getNodeContent($node);

		if ($selector[0] == '/'){// || $selector[0] == '('){
			if (!$rootNode)
				return null;
			
			$ret = $this->getNode($rootNode, $selector);
			return $isChild && is_array($ret) ? array_shift($ret) : $ret;
		}
		
		if ($selector[0] == '@'){
			if (!$node)
				return null;
				
			return (string) $this->getAttribute($node, substr($selector, 1));
		}

		if (substr($selector, 0, 2) == './')
			return $this->getNodeChild($node, substr($selector, 2));
		
		if (is_string($childConfig))
			return $childConfig;
			
		die('error in parsingProtocole, selector '.$selector);
	}

	// "@" selector (attribute)
	public function getAttribute($node, $selector){
		$attr = $node->attributes();
		return (string) $attr[$selector];
	}
	
	// "/" selector (xpath style selector)
	public function getNode($rootNode, $selector){
		$selector = explode('@', $selector);
		$fsel = preg_replace('#^(.*?)/?$#', '$1', $selector[0]);
		
		if (empty($fsel)){
			// pure attribute selector
			$fsel = '@'.$selector[1];
			$selector = array($fsel);
		}
		
		//echo $fsel.(!empty($selector[1]) ? ' / @'.$selector[1] : '').'<br>';
		$node = $rootNode->xpath($fsel);
		if (count($selector) > 1){
			if (is_array($node)){
				if (!$node)
					return null;
				$node = $node[0];
			}
			$attr = $node->attributes();
			return !empty($attr[$selector[1]]) ? ((string) $attr[$selector[1]]) : null;
		}
		return $node;
	}
	
	// "./" selector (get child node)
	public function getNodeChild($node, $selector){
		return $node->{$selector};
	}
	
	// "." selector (get text value)
	public function getNodeContent($node){
		$value = $node->asXML();
		
//		$value = kaosConvertEncoding($value);
		
		// html escaping
		$cleanValue = '';
		foreach (explode('<p', $value) as $i => $line){
			$line = trim(strip_tags($i ? '<p'.$line : $line));
			if ($line != '')
				$cleanValue .= $line.P_DILIMITER;//"\n\n";
		}
		return $cleanValue;
	}
}
