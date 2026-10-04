.class Lcn/uc/a/a/a/c;
.super Ljava/lang/Object;


# instance fields
.field private a:Lcn/uc/a/a/a/e;

.field private b:I

.field private c:Z


# direct methods
.method public constructor <init>(Lcn/uc/a/a/a/e;IZ)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcn/uc/a/a/a/c;->a:Lcn/uc/a/a/a/e;

    iput p2, p0, Lcn/uc/a/a/a/c;->b:I

    iput-boolean p3, p0, Lcn/uc/a/a/a/c;->c:Z

    return-void
.end method


# virtual methods
.method public a()Lcn/uc/a/a/a/e;
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/c;->a:Lcn/uc/a/a/a/e;

    return-object v0
.end method

.method public b()I
    .locals 1

    iget v0, p0, Lcn/uc/a/a/a/c;->b:I

    return v0
.end method

.method public c()Z
    .locals 1

    iget-boolean v0, p0, Lcn/uc/a/a/a/c;->c:Z

    return v0
.end method
