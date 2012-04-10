<?php
require('lib/header.php');
require('lib/lib_qa.php');
require_once('lib/lib_xml.php');
require_once('lib/lib_annot.php');

$action = isset($_GET['act']) ? $_GET['act'] : '';

if ($action && !in_array($action, array('samples', 'candidates')) && !user_has_permission('perm_check_morph')) {
    show_error($config['msg']['notadmin']);
    return;
}

switch($action) {
    case 'add':
        if (add_morph_pool()) {
            header("Location:pools.php?added");
        } else {
            show_error();
        }
        break;
    case 'delete':
        if (delete_morph_pool((int)$_GET['pool_id'])) {
            header("Location:pools.php");
        } else {
            show_error("Ошибка. Возможно, пул содержит пользовательские ответы.");
        }
    case 'candidates':
        $smarty->assign('candidates', get_pool_candidates((int)$_GET['pool_id']));
        $smarty->display('qa/pool_candidates.tpl');
        break;
    case 'samples':
        $smarty->assign('pool', get_morph_samples_page((int)$_GET['pool_id'], isset($_GET['ext']), isset($_GET['disagreed'])));
        $smarty->display('qa/pool.tpl');
        break;
    case 'promote':
        if (promote_samples((int)$_GET['pool_id'], $_GET['type'])) {
            header("Location:pools.php?act=samples&pool_id=".(int)$_GET['pool_id']);
        } else {
            show_error();
        }
        break;
    case 'publish':
        if (publish_pool((int)$_GET['pool_id'])) {
            header("Location:pools.php?act=samples&pool_id=".(int)$_GET['pool_id']);
        } else {
            show_error();
        }
        break;
    case 'unpublish':
        if (unpublish_pool((int)$_GET['pool_id'])) {
            header("Location:pools.php?act=samples&pool_id=".(int)$_GET['pool_id']);
        } else {
            show_error();
        }
        break;
    case 'begin_moder':
        if (moderate_pool((int)$_GET['pool_id'])) {
            header("Location:pools.php?act=samples&pool_id=".(int)$_GET['pool_id']);
        } else {
            show_error("Ошибка. Возможно, пул не полностью заполнен.");
        }
    default:
        $smarty->assign('pools', get_morph_pools_page());
        $smarty->display('qa/pools.tpl');
}
