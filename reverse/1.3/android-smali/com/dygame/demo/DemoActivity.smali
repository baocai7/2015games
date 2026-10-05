.class public Lcom/dygame/demo/DemoActivity;
.super Landroid/app/Activity;
.source "DemoActivity.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 9
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 14
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 15
    sget v0, Lcom/dygame/dysdk/R$layout;->dysdk_demo:I

    invoke-virtual {p0, v0}, Lcom/dygame/demo/DemoActivity;->setContentView(I)V

    .line 19
    invoke-static {p0}, Lcom/dygame/dysdk/DYSdkHelper;->init(Landroid/content/Context;)V

    .line 21
    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/dygame/dysdk/DYSdkHelper;->login(Landroid/app/Activity;Lcom/dygame/dysdk/DYSdkLoginListener;)V

    .line 22
    return-void
.end method
