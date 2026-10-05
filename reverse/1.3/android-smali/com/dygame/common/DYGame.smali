.class public Lcom/dygame/common/DYGame;
.super Lorg/cocos2dx/lua/AppActivity;
.source "DYGame.java"


# static fields
.field public static MAX_LOADING_TICK:I

.field public static theActivity:Lcom/dygame/common/DYGame;


# instance fields
.field private mViewLoading:Landroid/view/View;

.field private mViewRoot:Landroid/view/View;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 19
    const/4 v0, 0x0

    sput-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    .line 20
    const/16 v0, 0x1388

    sput v0, Lcom/dygame/common/DYGame;->MAX_LOADING_TICK:I

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .prologue
    const/4 v0, 0x0

    .line 18
    invoke-direct {p0}, Lorg/cocos2dx/lua/AppActivity;-><init>()V

    .line 22
    iput-object v0, p0, Lcom/dygame/common/DYGame;->mViewRoot:Landroid/view/View;

    .line 23
    iput-object v0, p0, Lcom/dygame/common/DYGame;->mViewLoading:Landroid/view/View;

    return-void
.end method

.method private initEnv()V
    .locals 0

    .prologue
    .line 60
    sput-object p0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    .line 61
    return-void
.end method

.method private onCustomCreate()V
    .locals 3

    .prologue
    .line 89
    invoke-static {}, Lcom/dygame/open/dataeye/DYDataEyeHelper;->onCreate()V

    .line 92
    invoke-virtual {p0}, Lcom/dygame/common/DYGame;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    sget-object v2, Lcom/dygame/open/baidu/DYBPushHelper;->API_KEY:Ljava/lang/String;

    invoke-static {v0, v1, v2}, Lcom/baidu/android/pushservice/PushManager;->startWork(Landroid/content/Context;ILjava/lang/String;)V

    .line 95
    invoke-direct {p0}, Lcom/dygame/common/DYGame;->onCustomLayout()V

    .line 96
    return-void
.end method

.method private onCustomDestroy()V
    .locals 0

    .prologue
    .line 108
    invoke-static {}, Lcom/dygame/open/dataeye/DYDataEyeHelper;->onDestroy()V

    .line 109
    return-void
.end method

.method private onCustomLayout()V
    .locals 6
    .annotation build Landroid/annotation/SuppressLint;
        value = {
            "HandlerLeak"
        }
    .end annotation

    .prologue
    .line 71
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v1

    .line 72
    .local v1, "inflater":Landroid/view/LayoutInflater;
    const/high16 v3, 0x7f030000

    const/4 v4, 0x0

    invoke-virtual {v1, v3, v4}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v2

    .line 73
    .local v2, "v":Landroid/view/View;
    iget-object v3, p0, Lcom/dygame/common/DYGame;->mFrameLayout:Landroid/widget/FrameLayout;

    invoke-virtual {v3, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V

    .line 74
    iput-object v2, p0, Lcom/dygame/common/DYGame;->mViewRoot:Landroid/view/View;

    .line 76
    iget-object v3, p0, Lcom/dygame/common/DYGame;->mViewRoot:Landroid/view/View;

    const v4, 0x7f080003

    invoke-virtual {v3, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    iput-object v3, p0, Lcom/dygame/common/DYGame;->mViewLoading:Landroid/view/View;

    .line 78
    new-instance v0, Lcom/dygame/common/DYGame$1;

    invoke-direct {v0, p0}, Lcom/dygame/common/DYGame$1;-><init>(Lcom/dygame/common/DYGame;)V

    .line 84
    .local v0, "h":Landroid/os/Handler;
    const/4 v3, 0x0

    sget v4, Lcom/dygame/common/DYGame;->MAX_LOADING_TICK:I

    int-to-long v4, v4

    invoke-virtual {v0, v3, v4, v5}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    .line 85
    return-void
.end method

.method private onCustomPause()V
    .locals 0

    .prologue
    .line 104
    invoke-static {}, Lcom/dygame/open/dataeye/DYDataEyeHelper;->onPause()V

    .line 105
    return-void
.end method

.method private onCustomResume()V
    .locals 0

    .prologue
    .line 100
    invoke-static {}, Lcom/dygame/open/dataeye/DYDataEyeHelper;->onResume()V

    .line 101
    return-void
.end method


# virtual methods
.method public doHideLoading(Ljava/lang/String;)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 64
    iget-object v0, p0, Lcom/dygame/common/DYGame;->mViewLoading:Landroid/view/View;

    if-eqz v0, :cond_0

    .line 65
    iget-object v0, p0, Lcom/dygame/common/DYGame;->mViewLoading:Landroid/view/View;

    const/4 v1, 0x4

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    .line 67
    :cond_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 0
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 27
    invoke-super {p0, p1}, Lorg/cocos2dx/lua/AppActivity;->onCreate(Landroid/os/Bundle;)V

    .line 28
    invoke-direct {p0}, Lcom/dygame/common/DYGame;->initEnv()V

    .line 30
    invoke-direct {p0}, Lcom/dygame/common/DYGame;->onCustomCreate()V

    .line 31
    return-void
.end method

.method protected onDestroy()V
    .locals 0

    .prologue
    .line 53
    invoke-super {p0}, Lorg/cocos2dx/lua/AppActivity;->onDestroy()V

    .line 55
    invoke-direct {p0}, Lcom/dygame/common/DYGame;->onCustomDestroy()V

    .line 56
    return-void
.end method

.method protected onPause()V
    .locals 0

    .prologue
    .line 45
    invoke-super {p0}, Lorg/cocos2dx/lua/AppActivity;->onPause()V

    .line 47
    invoke-direct {p0}, Lcom/dygame/common/DYGame;->onCustomPause()V

    .line 48
    return-void
.end method

.method protected onResume()V
    .locals 0

    .prologue
    .line 37
    invoke-super {p0}, Lorg/cocos2dx/lua/AppActivity;->onResume()V

    .line 39
    invoke-direct {p0}, Lcom/dygame/common/DYGame;->onCustomResume()V

    .line 40
    return-void
.end method
