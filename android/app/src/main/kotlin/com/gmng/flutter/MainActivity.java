package com.gmng.flutter;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.ActionBar;

import com.clevertap.android.sdk.ActivityLifecycleCallback;
import com.clevertap.android.sdk.CleverTapAPI;
import com.facebook.FacebookSdk;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.pocket52.poker.application.ERROR;
import com.pocket52.poker.application.IPokerListener;
import com.pocket52.poker.application.Pocket52PokerClient;
import com.pocket52.poker.application.PokerConfig;
import com.unity3d.player.UnityPlayerActivity;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.android.FlutterActivityLaunchConfigs;
import io.flutter.embedding.android.FlutterFragmentActivity;

import com.freshchat.consumer.sdk.flutter.FreshchatSdkPlugin;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;

import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import com.appsflyer.AppsFlyerLib;

import org.json.JSONObject;

import com.gl.platformmodule.PlatformService;
import com.gl.platformmodule.core.Constants;
import com.gl.platformmodule.core.interfaces.IGameEngine;
import com.gl.platformmodule.core.interfaces.IGameEventCallback;
import com.gl.platformmodule.core.interfaces.IGameEventListner;
import com.gl.platformmodule.core.models.GameConfig;
import com.gl.platformmodule.core.models.PlayerModel;
import com.gl.platformmodule.core.models.SdkConfig;
import com.gl.platformmodule.core.models.SdkEvent;
import com.gl.platformmodule.event.EventDataModel;
import com.gl.platformmodule.model.promotion.AllPromotion;
import com.gl.platformmodule.model.promotion.PromotionData;
import com.google.gson.Gson;

import in.glg.rummy.event.RummyEventType;
import in.glg.rummy.models.RummyEventsName;
import in.glg.rummy.activities.RummyInstance;

import org.json.JSONArray;


public class MainActivity extends FlutterFragmentActivity implements IPokerListener, PluginRegistrantCallback {
    private String CHANNEL = "com.gmng.flutter/channel";
    //    private lateinit var channel: MethodChannel;
    private String METHOD_HELLO = "OpenPocket52";
    private String METHOD_UNITYGAME = "UnityGames";
    private String INSTRAGRAM_SHARE = "InstagramShare";
    public static String walletCall = "click_icon_wallet";
    public MethodChannel.Result data;
    CleverTapAPI cleverTapAPI;
    AppsFlyerLib appsflyer;
    String user_id = "";
    String name = "";

    private String OPEN_LUDOKING = "OpenLudoKing";
    private String OPEN_RUMMY = "OpenRummy";
    public MethodChannel.Result data_rummy;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            Log.e("data-----", call.method);
                            data = result;
                            if (call.method.equalsIgnoreCase(METHOD_HELLO)) {
                                Map<String, String> data = call.arguments();
                                String token = data.get("token");
                                String url = data.get("url");
                                user_id = data.get("user_id");
                                Log.e("url----->", url);

                                //cleverTap initialisation
                                cleverTapAPI = CleverTapAPI.getDefaultInstance(getApplicationContext());
                                //appsflyer initialisation //Appsflyer code
                                appsflyer = AppsFlyerLib.getInstance();
                                appsflyer.setDebugLog(true);// For debug - remove in production
                                appsflyer.init("zFR25zR86SjqtBzRJKAUhJ", null, this);
                                appsflyer.start(this);

                                //starting pocker
                                initPoket52Sdk(token, url);

                            }
                            if (call.method.equalsIgnoreCase(METHOD_UNITYGAME)) {
                                Map<String, String> data = call.arguments();
//                            String unitydata = data.get("data");
//                            Log.e("unitydata----->",new Gson().fromJson(unitydata));

                                goToGameActiviy(data);
                            }
                            if (call.method.equalsIgnoreCase(INSTRAGRAM_SHARE)) {
                                String data = call.arguments();
                                intentInstagram(data);
                            }
                            if (call.method.equalsIgnoreCase(OPEN_LUDOKING)) {//NOT STRING
                                //String data = call.arguments();
                                openLudoKing();
                            }
                            if (call.method.equalsIgnoreCase(OPEN_RUMMY)) {
                                Map<String, String> data = call.arguments();

                                cleverTapAPI = CleverTapAPI.getDefaultInstance(getApplicationContext());
                                //appsflyer initialisation //Appsflyer code
                                appsflyer = AppsFlyerLib.getInstance();
                                appsflyer.setDebugLog(true);// For debug - remove in production
                                appsflyer.init("zFR25zR86SjqtBzRJKAUhJ", null, this);
                                appsflyer.start(this);


                                openRummy(data);
                            }
                        }
                );

    }

    @Override
    protected FlutterActivityLaunchConfigs.BackgroundMode getBackgroundMode() {
        return FlutterActivityLaunchConfigs.BackgroundMode.transparent;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // requestWindowFeature(Window.FEATURE_NO_TITLE);
        super.onCreate(savedInstanceState);
    }

    public void registerWith(PluginRegistry registry) {
        // FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
        FreshchatSdkPlugin.register(registry);
    }

    public void intentInstagram(String str) {
        try {
            Intent shareOnAppIntent = new Intent();
            shareOnAppIntent.setAction(Intent.ACTION_SEND);
            shareOnAppIntent.putExtra(Intent.EXTRA_TEXT, str);
            shareOnAppIntent.setType("text/plain");
            shareOnAppIntent.setPackage("com.instagram.android");
            startActivity(shareOnAppIntent);
        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(MainActivity.this, "APP is not installed", Toast.LENGTH_LONG).show();

        }
    }

    public void openLudoKing() {
        try {

            Intent shareOnAppIntent = new Intent();

            shareOnAppIntent.setPackage("com.ludo.king");//"com.ludo.king"
            startActivity(shareOnAppIntent);
        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(MainActivity.this, "APP is not installed", Toast.LENGTH_LONG).show();

        }
    }

    public void goToGameActiviy(Map<String, String> data) {

        Log.e("winning_type===", data.get("winning_type"));
        Log.e("winning_type_amount===", data.get("winning_type_amount"));

        String winning_type_data = data.get("winning_type");
        String winning_type_amount_data = data.get("winning_type_amount");
        String winning_type[] = new String[0];
        String winning_type_amount[] = new String[0];
        if (!winning_type_data.isEmpty()) {
            String data_value[] = winning_type_data.split(",");
            winning_type = new String[data_value.length];
            for (int i = 0; i < data_value.length; i++) {
                winning_type[i] = data_value[i];
                Log.e("winning_type values=>>>", winning_type[i]);
            }
        }
        if (!winning_type_amount_data.isEmpty()) {
            String data_value[] = winning_type_amount_data.split(",");
            winning_type_amount = new String[data_value.length];
            for (int i = 0; i < data_value.length; i++) {
                winning_type_amount[i] = data_value[i];
                Log.e("amount values=>>>", winning_type_amount[i]);
            }
        }

        GamePlayRequestModel gameModel = new GamePlayRequestModel();
        gameModel.email = data.get("email");
        gameModel.event_id = data.get("event_id");
//      gameModel.event_id = "8657";
        gameModel.game_id = data.get("game_id");
        gameModel.game_name = data.get("game_name");
        gameModel.is_championship = false;
        gameModel.is_test = false;
        gameModel.language = "en";
        gameModel.mobile = data.get("mobile");
        gameModel.name = data.get("name");
        gameModel.profile = data.get("profile");
        gameModel.user_id = data.get("user_id");
        gameModel.winning_type = winning_type;
        gameModel.winning_type_amount = winning_type_amount;

        Intent intent = new Intent(this, UnityPlayerActivity.class);
        if (gameModel != null) {
            Log.e("DATA===", new Gson().toJson(gameModel).toString());
            intent.putExtra("DATA", new Gson().toJson(gameModel));
        }
        startActivity(intent);
    }

    public void initPoket52Sdk(String token, String vendorKv) {
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("url", vendorKv);
        //PokerConfig config = new PokerConfig.Builder(this, token, jsonObject.toString(),MainActivity.this, "", false, false).build();//for poker-sdk-v1.6.4.aar
        PokerConfig config = new PokerConfig.
                Builder(this, token, jsonObject.toString(),
                MainActivity.this, "", false, false, "").build();//for poker-sdk-v1.8.1.aar
        Pocket52PokerClient.INSTANCE.initPoker(config);
    }

    @Override
    public void onPokerSuccess() {
        Pocket52PokerClient.INSTANCE.openPokerLobby(null);
    }

    @Override
    public void onPokerError(@Nullable ERROR error) {
        Log.e("pocket52", "ctmap1--" + error);


    }

    @Override
    public void onAddMoney(double v) {
        walletCall = "click_add_amount";

        data.success(walletCall);

        Intent intent = new Intent(MainActivity.this, MainActivity2.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);

        startActivity(intent);

    }

    @Override
    public void onEventTrigger(@Nullable String s, @Nullable Map<String, ?> map) {
        Log.e("pocket52", "event22--" + s);
        Log.e("pocket52", "event23--" + map.toString());
        switch (s) {
            case "click_helpdesk_profile":
                data.success("click_helpdesk_profile");
                break;
            case "click_buyin_success":
                HashMap<String, Object> ctmap1 = new HashMap<String, Object>();
                ctmap1.put("buyin_amount", map.get("cashgame_buyin_amount"));
                ctmap1.put("Ticket_money_used", map.get("Ticket_money_used"));
                ctmap1.put("Tablename", map.get("cashgame_Tablename"));
                ctmap1.put("maxplayers", map.get("cashgame_maxplayers"));
                ctmap1.put("Join status", map.get("status"));
                ctmap1.put("smallblind", map.get("cashgame_smallblind"));
                ctmap1.put("Game_type", map.get("game_type"));
                ctmap1.put("bigblind", map.get("Cashgame_bigblind"));
                ctmap1.put("USER_ID", user_id);

                cleverTapCustomeEvent("Poker Joined Contest", ctmap1);
                appsflyerCustomeEvent("Poker Joined Contest", ctmap1);

                cleverTapCustomeEvent("Joined Contest", ctmap1);
                appsflyerCustomeEvent("Joined Contest", ctmap1);

                Log.e("pocket52", "ctmap1--" + ctmap1.toString());
                break;
//            case "Click_LobbyName_Selected":
//                walletCall = "";
//                data.success("Click_LobbyName_Selected");
//                break;

            case "click_icon_wallet":
                walletCall = "click_icon_wallet";
                // data.success(walletCall);
                break;
            case "click_add_amount":
                walletCall = "click_add_amount";
                //  data.success(walletCall);
                break;

            case "tournament_register_success":

                HashMap<String, Object> map_tour = new HashMap<String, Object>();
                map_tour.put("tournament_gametype", map.get("tournament_gametype"));
                map_tour.put("tournament_ticket_exists", map.get("tournament_ticket_exists"));
                map_tour.put("tournament_prizepool", map.get("tournament_prizepool"));
                map_tour.put("tournament_entry_type", map.get("tournament_entry_type"));
                map_tour.put("tournament_RegistrationType_method", map.get("tournament_RegistrationType_method"));
                map_tour.put("touranment_starttime", map.get("touranment_starttime"));
                map_tour.put("tournament_total_buyin", map.get("tournament_total_buyin"));

                cleverTapCustomeEvent("tournament_register_success", map_tour);
                appsflyerCustomeEvent("tournament_register_success", map_tour);
                Log.e("pocket52 tournament", "map_tour--" + map_tour.toString());

                break;

        }

    }

    @Override
    public void onActionClicked(@Nullable String s, @Nullable String s1) {
        Log.e("pocket52", "event---" + s + "--" + s1);
        switch (s) {
            case "OPEN_LEADER_BOARD":
                data.success("OPEN_LEADER_BOARD");
                Intent intent = new Intent(MainActivity.this, MainActivity2.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);

                startActivity(intent);

                break;
        }
    }

    //cleverTap logEvents
    public void cleverTapCustomeEvent(String event_name, Map<String, Object> eventValues) {
        if (cleverTapAPI != null) {
            cleverTapAPI.pushEvent(event_name, eventValues);
        }
    }

    //appsflyer logEvents
    public void appsflyerCustomeEvent(String event_name, Map<String, Object> eventValues) {
        if (appsflyer != null) {
            appsflyer.logEvent(getApplicationContext(), event_name, eventValues);
        }
    }

    //Rummy
    public void openRummy(Map<String, String> data_map_r) {
        //Toast.makeText(MainActivity.this, "Rummy clicked Live!", Toast.LENGTH_LONG).show();
        try {
            //Toast.makeText(MainActivity.this, "Rummy Starting mainActivity...", Toast.LENGTH_LONG).show();
            new PlatformService.PlatformServiceBuilder(getApplication()).build();

            HashMap<String, String> map_rummy = new HashMap<String, String>();
            map_rummy.put("user_id", data_map_r.get("user_id"));
            map_rummy.put("name", data_map_r.get("name"));
            map_rummy.put("state", "haryana");
            // map_rummy.put("state", data_map_r.get("state"));
            map_rummy.put("country", "india");
            //   map_rummy.put("country", data_map_r.get("country"));
            map_rummy.put("session_key", data_map_r.get("session_key"));
            map_rummy.put("timestamp", data_map_r.get("timestamp"));
            map_rummy.put("client_id", data_map_r.get("client_id"));
            map_rummy.put("hash", data_map_r.get("hash"));
            Log.e("Rummy Data----->", map_rummy.toString());
            initRummy(map_rummy);


        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(MainActivity.this, "Some Error!!", Toast.LENGTH_LONG).show();

        }
    }

    //RUMMY WORK
    //RUMMY WORK


    private IGameEngine rummyGameEngine;

    private IGameEventListner getSdkEventListener(IGameEngine gameEngine) {
        return new GameEventListener(gameEngine);
    }

    private class GameEventListener implements IGameEventListner {
        private IGameEngine gameEngine;

        public GameEventListener(IGameEngine gameEngine) {
            this.gameEngine = gameEngine;
        }

        @Override
        public void onEvent(SdkEvent eventType, Map<String, String> data) {
            onEvent(eventType, data, data1 -> {
                // Toast.makeText(MainActivity.this, "DATA "+data.toString(), Toast.LENGTH_SHORT).show();
            });
        }

        @Override
        public void onEvent(SdkEvent eventType, Map<String, String> data_, IGameEventCallback callback) {
            if (eventType.toString().equalsIgnoreCase("topBarClicked")) {

                data.success("topBarClicked");
                //Toast.makeText(MainActivity.this, "DATA " + data.toString(), Toast.LENGTH_SHORT).show();
                this.gameEngine.close();
                //String event_name = data.get(RummyEventsName.KEY_TRACK_EVENT_NAME);
                // Toast.makeText(MainActivity.this, "DATA " + eventType.toString(), Toast.LENGTH_SHORT).show();

            } else if (eventType == SdkEvent.topBarClicked) {
                String top_click_type = data_.get(Constants.KEY_TOPBAR_CLICK_TYPE);
                if (top_click_type != null && top_click_type.equalsIgnoreCase(Constants.KEY_TOPBAR_CLICK_add_cash)) {
                    this.gameEngine.close();
                } else if (top_click_type != null && top_click_type.equalsIgnoreCase(Constants.KEY_TOPBAR_CLICK_profile)) {
                    this.gameEngine.close();
                } else if (top_click_type != null && top_click_type.equalsIgnoreCase(RummyEventsName.KEY_TOPBAR_CLICK_back_arrow)) {
                    this.gameEngine.close();
                }
                callback.onComplete(new JSONObject());
            } else if (eventType == SdkEvent.addCashClicked || eventType == SdkEvent.lowBalance) {
                data.success("click_add_amount");
                //Toast.makeText(MainActivity.this, "DATA " + data.toString(), Toast.LENGTH_SHORT).show();
                this.gameEngine.close();
            } else if (eventType == SdkEvent.stateBlockUpdateClick) {
                this.gameEngine.close();
            } else if (eventType == SdkEvent.requestPromotionData) {
                try {// [1]
                    AllPromotion promotions = new AllPromotion();
                    JSONArray promotion_array = new JSONArray("[{\"bannerImageUrl\":\"http://1168271595.rsc.cdn77.org/rummy.png\", \"deeplink\":\"addcash\", \"promotion_id\":\"1\"}," +
                            "{\"bannerImageUrl\":\"http://1168271595.rsc.cdn77.org/rummy1.png\", \"deeplink\":\"promotion\", \"promotion_id\":\"2\"}]");

                    for (int i = 0; i < promotion_array.length(); i++) {

                        JSONObject obj = promotion_array.getJSONObject(i);
                        PromotionData promotionData = new PromotionData();
                        promotionData.promotionId = Integer.parseInt(obj.getString("promotion_id"));
                        promotionData.deeplink = obj.getString("deeplink");
                        promotionData.bannerImageUrl = obj.getString("bannerImageUrl");
                        promotions.promotions.add(promotionData);

                    }
                    Gson gson = new Gson();
                    callback.onComplete(new JSONObject(gson.toJson(promotions)));

                } catch (Exception e) {
                    Log.e("vikas", "promotion event error" + e.getMessage());
                }

            } else if (eventType == SdkEvent.openPromotionDeepLink) {
                //when we click on banner
                //we will get value in >>data [2]
                //Toast.makeText(MainActivity.this, "DATA " + data.toString(), Toast.LENGTH_SHORT).show();

            } else if (eventType == SdkEvent.track_event) {
                String event_name = data_.get(RummyEventsName.KEY_TRACK_EVENT_NAME);
                String Tag = data_.get(RummyEventsName.KEY_TRACK_EVENT_TAG);
                RummyEventType eventType1 = RummyEventType.valueOf(event_name);//<<<<
            } else if (eventType == SdkEvent.closeSDK) {
                this.gameEngine.close();
            } else if (eventType == SdkEvent.track_event_data) {
                try {
                    //{bet=0.25, tableID=314364, GameType=PR_JOKER, track_event_name=cashGameClick}
                    cleverTapAPI = CleverTapAPI.getDefaultInstance(getApplicationContext());
                    appsflyer = AppsFlyerLib.getInstance();//new code
                    String event_name = data_.get(RummyEventsName.KEY_TRACK_EVENT_NAME);
                    RummyEventType eventType1 = RummyEventType.valueOf(event_name);
                    EventDataModel final_data = new EventDataModel();
                    HashMap<String, Object> map_rummy = new HashMap<String, Object>();
                    for (String key : data_.keySet()) {
                        //Log.v("CTevent",key);
                        //Log.v("CTevent",data_.get(key));
                        //if (!key.equalsIgnoreCase(RummyEventsName.KEY_TRACK_EVENT_NAME)) {
                        //Log.v("CTevent1",key);
                        //Log.v("CTevent1",data_.get(key));
                        final_data.put(key, data_.get(key));
                        map_rummy.put(key, data_.get(key));
                        //here we need to call Clevertap| Appsflyer
                        // }
                    }
                    if (map_rummy != null && map_rummy.size() > 0) {
                        cleverTapCustomeEvent("Rummy Joined Contest", map_rummy);
                        appsflyerCustomeEvent("Rummy Joined Contest", map_rummy);
                        cleverTapCustomeEvent("Joined Contest", map_rummy);
                        appsflyerCustomeEvent("Joined Contest", map_rummy);
                    }

                } catch (Exception e) {

                }

            }
        }

        @Override
        public GameConfig getGameConfig() {
            return null;
        }
    }

    private void initRummy(HashMap<String, String> map_rummy) {
        rummyGameEngine = RummyInstance.getInstance();
        //gmngexchange|631ed674512d5aca29064ba6|Ravi krishna|ravi@gmng.pro|9598848185|UP|INDIA||1669943459|8LkTm7vtWlFFvKu
        // staging or prod sdkConfig.setHelpLink("http://google.com");

        /*{"client_id":"gmngexchange", "user_id":"631ed674512d5aca29064ba6", "name":"Ravi Krishna", "email":"ravi@gmng.pro","mobile_number":"9598848185", "state":"UP", "country":"INDIA", "session_key":"", "timestamp":"1669943459", "hash": "01d122163a5803f2622df663dacdda47395a06455273c8da948af196b4840ff5"}*/


        PlayerModel player = new PlayerModel();
        player.setAuthToken(new Gson().toJson(map_rummy).toString());
        user_id = map_rummy.get("user_id");
        name = map_rummy.get("name");

        Log.e("Rummy Data  name----->", name.toString());

        player.setUserName(name); // Pass Username/DisplayName
        SdkConfig sdkConfig = new SdkConfig();
        //stage
        //sdkConfig.setSdkMode("staging"); // staging or prod sdkConfig.setHelpLink("http://google.com");
        //sdkConfig.setMerchantId("gmngexchange");
        //live
        sdkConfig.setSdkMode("prod");
        sdkConfig.setMerchantId("gmng-exchange");
        sdkConfig.setAssetsFolderName("test");
        sdkConfig.setHelpLink("https://gmng.pro/how-to-play-rummy/");//how to play [3]
        rummyGameEngine.initEngine(this, getSdkEventListener(rummyGameEngine), player, sdkConfig);
        rummyGameEngine.startSDK(this);
    }


}
